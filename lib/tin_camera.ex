defmodule TinCamera do
  @gpio Application.get_env(:circuits_gpio, :gpio, Circuits.GPIO)

  use GenServer

  require Logger

  @spec start_link(TinCamera.Config.t) :: GenServer.on_start
  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  @impl GenServer
  def init(config) do
    {:ok, gpio} = @gpio.open(config.pin, :input)
    @gpio.set_interrupts(gpio, :both)
    {:ok, %{gpio: gpio}}
  end

  @impl GenServer
  def handle_info({:circuits_gpio, _pin, _timestamp, 0}, state) do
    Logger.debug("Motion sensor tripped!")
    
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:circuits_gpio, _pin, _timestamp, 1}, state) do
    Logger.debug("Motion sensor off!")
    
    Picam.next_frame()
      |> Base.encode64()
      |> Logger.debug()

    {:noreply, state}
  end
end
