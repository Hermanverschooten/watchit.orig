defmodule Watchit do
  use Application

  @alarm Application.get_env(:watchit, :alarm)
  @door Application.get_env(:watchit, :door)
  @fire Application.get_env(:watchit, :fire)
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Watchit.Worker.start_link(arg1, arg2, arg3)
      # worker(Watchit.Worker, [arg1, arg2, arg3]),
      worker(Watchit.Alarm, [@alarm]),
      worker(Watchit.PinWatch, [@door], id: :door),
      worker(Watchit.PinWatch, [@fire], id: :fire)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Watchit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
