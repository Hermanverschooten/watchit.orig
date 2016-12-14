defmodule Watchit.Alarm do
  require Logger
  alias Watchit.Play
  use GenServer

  def start_link(opts) do
    GenServer.start_link __MODULE__, opts
  end

  def init(state) do
    Logger.info "Alarm worker started"
    Process.send_after(self(), :tick, (60 - DateTime.utc_now.second) * 1000)
    {:ok, state}
  end

  def handle_info(:tick, state) do
    Logger.debug "tick"
    Process.send_after(self(), :tick, 60_000)
    case now?(state[:time], :calendar.local_time) do
      true -> 
        Logger.info "Time reached - playing"
        Play.sound(state)
      false -> :ok
    end
    {:noreply, state}
  end

  def now?(time1, {_, {h, m, _}}), do: {time1.hour, time1.minute} == {h, m}
end
