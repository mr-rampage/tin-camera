defmodule TinCamera.Config do
  @enforce_keys [:pin, :topic]
  defstruct [:pin, :topic]

  @type t :: %TinCamera.Config{pin: non_neg_integer(), topic: atom()}
end
