require 'test_helper'
require "active_support/all"
require 'ten_hs_server'

class RoomTest < ActiveSupport::TestCase
  test "should load all rooms" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevices",
    ).returns(
      stub body: fixture("devices_result.html")
    )

    rooms = TenHsServer::Room.all

    assert_equal 5, rooms.count
  end

  test "should load a room" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevices",
    ).returns(
      stub body: fixture("devices_result.html")
    )

    room = TenHsServer::Room.new "Dining room"
    assert_equal "Dining room", room.name
    assert_equal 2, room.devices.count
  end

  test "should turn on everything in a room" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevices",
    ).returns(
      stub body: fixture("devices_result.html")
    )
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOn&d=Q5",
    ).returns(
      stub body: fixture("device_on_result.html")
    )
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOn&d=Q12",
    ).returns(
      stub body: fixture("device_on_result.html")
    )

    room = TenHsServer::Room.new "Dining room"
    assert_equal true, room.on
  end

  test "should turn off everything in a room" do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevices",
    ).returns(
      stub body: fixture("devices_result.html")
    )
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOff&d=Q5",
    ).returns(
      stub body: fixture("device_off_result.html")
    )
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=DeviceOff&d=Q12",
    ).returns(
      stub body: fixture("device_off_result.html")
    )

    room = TenHsServer::Room.new "Dining room"
    assert_equal true, room.off
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