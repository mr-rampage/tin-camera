
defmodule MotionSensor.Config do
    @enforce_keys [:pin, :on_trigger, :on_release]
    defstruct [:pin, :on_trigger, :on_release]
end