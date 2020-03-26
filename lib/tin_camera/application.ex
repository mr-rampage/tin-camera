defmodule TinCamera.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @input_pin Application.get_env(:tin_camera, :switch_pin, 17)
  @camera Application.get_env(:picam, :camera, Picam.Camera)

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TinCamera.Supervisor]

    camera_config = %TinCamera.Config{
      :pin => @input_pin,
      :client_id => "front-door"
    }

    children = [
      @camera,
      {TinCamera, camera_config},
      Tortoise.Connection.start_link(
        client_id: TinCamera.Config.client_id,
        server: {Tortoise.Transport.Tcp, host: 'localhost', port: 1883},
        handler: {Tortoise.Handler.Logger, []}
      )
    ]

    Supervisor.start_link(children, opts)
  end
end
