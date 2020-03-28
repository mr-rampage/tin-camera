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
    {:ok, gpio} = @gpio.open(Keyword.get(config, :pin, "17") |> String.to_integer(), :input)
    @gpio.set_interrupts(gpio, :both)

    client_id = Keyword.get(config, :mqtt_client_id, "nerves-client")
    topic = Keyword.get(config, :mqtt_topic, "cameras")
    location = Keyword.get(config, :location, "front")

    {:ok, mqtt} = Tortoise.Connection.start_link(
        client_id: client_id,
        server: {
          Tortoise.Transport.Tcp, 
          host: Keyword.get(config, :mqtt_host, "localhost"), 
          port: Keyword.get(config, :mqtt_port, "1883") |> String.to_integer()
        },
        handler: {Tortoise.Handler.Logger, []}
    )

    Picam.set_size(1280, 0)

    {:ok, %{gpio: gpio, client_id: client_id, mqtt: mqtt, topic: topic, location: location}}
  end

  @impl GenServer
  def handle_info({:circuits_gpio, _pin, _timestamp, 0}, state) do
    Logger.debug("Motion sensor off!")
    
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:circuits_gpio, _pin, _timestamp, 1}, state) do
    Logger.debug("Motion sensor tripped!")

    Tortoise.publish(
      state.client_id, 
      state.topic,
      create_message(state.location),
      [qos: 1]
    )

    {:noreply, state}
  end

  def handle_info({{Tortoise, _client_id}, _ref, :ok}, state) do
    Logger.info("Message published!")
    {:noreply, state}
  end

  def handle_info({{Tortoise, _client_id}, _ref, _res}, state) do
    Logger.info("Message error?")
    {:noreply, state}
  end

  defp create_message(location) do
    "motion,room=#{location} frame=\"#{Picam.next_frame |> Base.encode64()}\""
  end
end
