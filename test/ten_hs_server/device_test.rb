require 'test_helper'
require "active_support/all"
require 'ten_hs_server'

class DeviceTest < ActiveSupport::TestCase
  client = TenHsServer.new '10.0.0.71'

  test "should load all devices" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevices",
    ).returns(
      stub body: fixture("devices_result.html")
    )

    devices = client.device.all

    assert_equal 13, devices.count
  end

  test "should load a single device" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevice&d=Q12",
    ).returns(
      stub body: fixture("device_result.html")
    )

    device = client.device.new "Q12"
    assert_equal "Chandelier", device.name
  end

  test "should load a single insteon device" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevice&d=%5C15",
    ).returns(
      stub body: fixture("insteon_device_result.html")
    )

    device = client.device.new "\\15"
    assert_equal "Chandelier", device.name
  end

  test "should toggle a device" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=ToggleDevice&d=Q12",
    ).returns(
      stub body: fixture("toggle_device_result.html")
    )

    device = client.device.new "Q12"
    assert_equal 2, device.toggle[:status]
  end

  test "should turn on a device" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOn&d=Q12",
    ).returns(
      stub body: fixture("device_on_result.html")
    )

    device = client.device.new "Q12"
    assert_equal 2, device.on[:status]
  end

  test "should turn off a device" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOff&d=Q12",
    ).returns(
      stub body: fixture("device_off_result.html")
    )

    device = client.device.new "Q12"
    assert_equal 3, device.off[:status]
  end

  test "should dim a device" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOn&d=Q12",
    ).returns(
      stub body: fixture("device_on_result.html")
    )
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=SetDeviceValue&d=Q12&a=70",
    ).returns(
      stub body: fixture("set_device_value_result.html")
    )

    device = client.device.new "Q12"
    assert_equal 70, device.dim(70)
  end

  test "should ask a device if its on or off" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevice&d=Q12",
    ).returns(
      stub body: fixture("device_result.html")
    )

    device = client.device.new "Q12"
    assert_equal false, device.on?
    assert_equal true, device.off?
  end

  private

  # Load a fixture.
  #
  # name - A string describing the name of the fixture load.
  #
  # Returns a string describing the contents of the fixture.
  def fixture name
    cwd = File.expand_path(File.dirname(__FILE__))
    File.read(File.join(cwd, "../fixtures/ten_hs_server/#{name}"))
  end
end