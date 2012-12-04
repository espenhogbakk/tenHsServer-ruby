require 'test_helper'
require "active_support/all"

class DevicesTest < ActiveSupport::TestCase
  setup do
    TenHsServer::Device.expects(:get).with(
      "?t=99&f=GetDevices",
    ).returns(
      stub body: fixture("devicesresult.html")
    )
  end

  test "should load all devices" do
    devices = TenHsServer::Device.all

    assert_equal 13, devices.count
  end

  test "should load a single device" do
    device = TenHsServer::Device.find "Q12"

    assert_equal "Q12", device[:id]
    assert_equal "Chandelier", device[:name]
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