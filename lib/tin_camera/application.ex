defmodule TinCamera.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @input_pin Application.get_env(:tin_camera, :switch_pin, 17)

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TinCamera.Supervisor]
    children =
      [
        PubSub,
        { 
          MotionSensor, 
          %MotionSensor.Config{ 
            :pin => @input_pin, 
            :topic => :motion_detector 
          }
        },
        {
          TinCamera.Logger,
          %TinCamera.Logger{
            :topic => :motion_detector
          }
        }
      ]
    Supervisor.start_link(children, opts)
  end

  def target() do
    Application.get_env(:tin_camera, :target)
  end
end
