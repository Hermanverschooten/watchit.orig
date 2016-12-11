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
    :ok = GpioRpi.set_int(pid, :both)
    {:ok, opts ++ [ pid: pid, pin_state: nil, last: 0]}
  end

  def handle_info({:gpio_interrupt, _pin, :falling}, state) do
    Logger.debug "#{state[:pin]} - Falling"
    state = case state[:pin_state] do
      :rising ->
        case play(state) do
          :played -> update(state, :last, now)
          _ -> state
        end 
      :falling ->
        Logger.debug "#{state[:pin]} - State is still triggered."
        state
      nil ->
        Logger.debug "#{state[:pin]} - Initial state set"
        update(state, :last, now)
    end
    {:noreply, update(state, :pin_state, :falling)}
  end

  def handle_info({:gpio_interrupt, _pin, :rising}, state) do
    Logger.debug "#{state[:pin]} - Rising"
    {:noreply, update(state, :pin_state, :rising)}
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
