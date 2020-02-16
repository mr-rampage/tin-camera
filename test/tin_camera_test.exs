defmodule TinCameraTest do
  use ExUnit.Case, async: true 
  doctest TinCamera 

  test "should not crash on motion" do
    actual = TinCamera.handle_info({:motion}, %{topic: :test_topic})
    assert actual == {:noreply, %{topic: :test_topic}}
  end

  test "should not crash on no_motion" do
    actual = TinCamera.handle_info({:no_motion}, %{topic: :test_topic})
    assert actual == {:noreply, %{topic: :test_topic}}
  end
end