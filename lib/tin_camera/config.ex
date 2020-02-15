defmodule TinCamera.Config do
  @enforce_keys [:pin, :topic]
  defstruct [:pin, :topic]
end
