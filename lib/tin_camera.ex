defmodule TinCamera do
  use GenServer

  require Logger

  @spec start_link(TinCamera.Config.t) :: GenServer.on_start
  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  @impl GenServer
  def init(config) do
    PubSub.subscribe(self(), config.topic)
    {:ok, config}
  end

  @impl GenServer
  def handle_info({:motion}, state) do
    Picam.next_frame()
      |> Base.encode64()
      |> Logger.debug()

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:no_motion}, state) do
    {:noreply, state}
  end
end
