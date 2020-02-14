defmodule TinCamera.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @input_pin Application.get_env(:tin_camera, :switch_pin, 17)

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TinCamera.Supervisor]
    children =
      [
        { 
          MotionSensor, 
          %MotionSensor.Config{
            :pin => @input_pin,
            :on_trigger => fn () -> Logger.debug("Motion sensor tripped!") end,
            :on_release => fn () -> Logger.debug("Motion sensor off!") end
          }
        }
        # Children for all targets
        # Starts a worker by calling: TinCamera.Worker.start_link(arg)
        # {TinCamera.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: TinCamera.Worker.start_link(arg)
      # {TinCamera.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: TinCamera.Worker.start_link(arg)
      # {TinCamera.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:tin_camera, :target)
  end
end
