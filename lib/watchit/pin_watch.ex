defmodule Watchit.PinWatch do
  require Logger
  use GenServer
  alias Watchit.Play

  def start_link(opts) do
    GenServer.start_link __MODULE__, opts
  end

  def init(opts) do
    Logger.info "#{opts[:pin]} - Started worker PinWatch"
    {:ok, pid} = GpioRpi.start_link(opts[:pin], :input)
    GpioRpi.set_mode pid, :down
    Process.send_after(self, :tick, 1000)
    {:ok, opts ++ [ pid: pid, pin_state: GpioRpi.read(pid), last: 0]}
  end

  def handle_info(:tick, state) do
    state = run(GpioRpi.read(state[:pid]), state[:pin_state], state)
    Process.send_after(self, :tick, 1000)
    {:noreply, state}
  end

  def run(0,1, state) do
    Logger.debug "#{state[:pin]} - 1 -> 0"
    state = case play(state) do
      :played -> update(state, :last, now)
      _ -> state
    end 
    update(state, :pin_state, 0)
  end

  def run(new_state, _, state) do
    update(state, :pin_state, new_state)
  end

  defp now, do: DateTime.utc_now |> DateTime.to_unix

  defp play(state) do
    play(now - state[:last] > 60, state)
  end

  defp play(true, state) do
    Logger.info "#{state[:pin]} - State triggered - Playing"
    Play.sound(state)
    :played
  end

  defp play(false, state) do
    Logger.info "#{state[:pin]} - State triggered - NOT Playing - too soon"
    :ok
  end

  defp update(state, key, value) do
    state 
    |> Enum.into(%{})
    |> Map.put(key,value)
    |> Map.to_list
  end
end
