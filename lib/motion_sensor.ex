defmodule MotionSensor do
    @moduledoc """
    Simple PIR motion sensor
    """
    use GenServer

    def start_link(config) do
        GenServer.start_link(__MODULE__, config, name: __MODULE__)
    end

    @impl GenServer
    def init(config) do
        {:ok, gpio} = Circuits.GPIO.open(config.pin, :input)
        Circuits.GPIO.set_interrupts(gpio, :both)
        {:ok, %{gpio: gpio, topic: config.topic}}
    end

    @impl GenServer
    def handle_info({:circuits_gpio, _pin, _timestamp, 0}, state) do
        PubSub.publish(state.topic, {:no_motion})
        {:noreply, state}
    end

    @impl GenServer
    def handle_info({:circuits_gpio, _pin, _timestamp, 1}, state) do
        PubSub.publish(state.topic, {:motion})
        {:noreply, state}
    end
end