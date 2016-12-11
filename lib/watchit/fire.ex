defmodule Watchit.Fire do
  require Logger
  alias Watchit.Play

  @pin Application.get_env(:watchit, :pins)[:fire]

  def start_link do
     {:ok, pid } = GpioRpi.start_link(@pin, :input)
     GpioRpi.set_mode pid, :up
     loop(pid, GpioRpi.read(pid))
  end

  defp loop(pid, state) do
    loop(pid, run(GpioRpi.read(pid), state))
  end

  defp run(0, 1) do
    Logger.info "Fire Alarm triggered!"
    Play.sound(:fire)
    0
  end

  defp run(state,_) do
    Process.sleep 100
    state
  end
end
