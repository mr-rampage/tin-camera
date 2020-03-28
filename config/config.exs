# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

config :tin_camera, 
  target: Mix.target(),
  mqtt_host: System.get_env("MQTT_HOST"),
  mqtt_port: System.get_env("MQTT_PORT"),
  mqtt_client_id: System.get_env("MQTT_CLIENT_ID")


# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1581567598"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

if Mix.target() != :host do 
  import_config "target.exs"
end

if Mix.env() == :test do
  import_config "test.exs"
end
