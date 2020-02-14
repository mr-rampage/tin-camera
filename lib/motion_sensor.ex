defmodule MotionSensor do
    @moduledoc """
    Simple PIR motion sensor
    """
    use GenServer

    def start_link(config) do
        GenServer.start_link(__MODULE__, config, name: __MODULE__)
    end

    @impl GenServer
    def init(%MotionSensor.Config{pin: input_pin} = config) do
        {:ok, gpio} = Circuits.GPIO.open(input_pin, :input)
        Circuits.GPIO.set_interrupts(gpio, :both)
        {:ok, create_state(config, gpio)}
    end

    @impl GenServer
    def handle_info({:circuits_gpio, _pin, _timestamp, 0}, state) do
        state.on_release.()
        {:noreply, state}
    end

    @impl GenServer
    def handle_info({:circuits_gpio, _pin, _timestamp, 1}, state) do
        state.on_trigger.()
        {:noreply, state}
    end

    defp create_state(config, gpio) do
        %{
            :on_release => config.on_release,
            :on_trigger => config.on_trigger,
            :gpio => gpio
        }
    end
end