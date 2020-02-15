defmodule TinCamera.Logger do
    @enforce_keys [:topic]
    defstruct [:topic]

    use GenServer

    require Logger

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
        Logger.debug("Motion sensor tripped!")
        {:noreply, state}
    end

    @impl GenServer
    def handle_info({:no_motion}, state) do
        Logger.debug("Motion sensor off!")
        {:noreply, state}
    end
end