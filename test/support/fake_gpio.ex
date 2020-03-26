defmodule FakeGPIO do
  def open(_pin_number, _pin_direction) do
    Task.start(fn -> IO.puts("Faking GPIO") end)
  end

  def set_interrupts(_gpio, _direction) do
  end
end