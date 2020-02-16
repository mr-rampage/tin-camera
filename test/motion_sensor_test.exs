
defmodule MotionSensorTest do
  use ExUnit.Case, async: true 
  doctest MotionSensor

  test "should publish a :no_motion message when PIR goes low" do
    topic = :motion_detector
    PubSub.subscribe(self(), topic)
    MotionSensor.handle_info({:circuits_gpio, nil, nil, 0}, %{topic: topic})
    assert_receive {:no_motion}
  end

  test "should publish a :motion message when PIR goes low" do
    topic = :motion_detector
    PubSub.subscribe(self(), topic)
    MotionSensor.handle_info({:circuits_gpio, nil, nil, 1}, %{topic: topic})
    assert_receive {:motion}
  end
end
