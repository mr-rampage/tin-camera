defmodule TinCamera.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @config Application.get_all_env(:tin_camera)
  @camera Application.get_env(:picam, :camera, Picam.Camera)

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TinCamera.Supervisor]

    children = [
      @camera,
      {TinCamera, @config}
    ]

    Supervisor.start_link(children, opts)
  end
end
