defmodule TinCamera.Config do
  @enforce_keys [:pin]
  defstruct [:pin]

  @type t :: %TinCamera.Config{pin: non_neg_integer()}
end
