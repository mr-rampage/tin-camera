defmodule TinCamera.Config do
  @enforce_keys [:pin, :client_id]
  defstruct [:pin, :client_id]

  @type t :: %TinCamera.Config{pin: non_neg_integer(), client_id: String.t()}
end
