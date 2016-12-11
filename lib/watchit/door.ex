defmodule Watchit.Door do
  require Logger
  alias Watchit.Play

  @pin Application.get_env(:watchit, :pins)[:door]

  def main do
     {:ok, pid } = GpioRpi.start_link(@pin, :input)
     GpioRpi.set_mode pid, :up
     loop(pid, GpioRpi.read(pid))
  end

  defp loop(pid, state) do
    loop(pid, run(GpioRpi.read(pid), state))
  end

  defp run(0, 1) do
    Logger.info "Door Alarm triggered!"
    Play.sound :door
    0
  end

  defp run(state,_) do
    Process.sleep 100
    state
  end
end
