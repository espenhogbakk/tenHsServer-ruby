require 'test_helper'
require "active_support/all"
require 'ten_hs_server'

class EventTest < ActiveSupport::TestCase
  test "should load all events" do
    TenHsServer::Event.expects(:get).with(
      "?t=99&f=GetEvents",
    ).returns(
      stub body: fixture("events_result.html")
    )

    events = TenHsServer::Event.all

    assert_equal 8, events.count
  end

  test "should load a single event" do
    TenHsServer::Event.expects(:get).with(
      "?t=99&f=GetEvents",
    ).returns(
      stub body: fixture("events_result.html")
    )

    event = TenHsServer::Event.find "All on"
    assert_equal "All on", event
  end

  test "should run an event" do
    TenHsServer::Event.expects(:get).with(
      "?t=99&f=RunEvent&d=All%20on",
    ).returns(
      stub body: fixture("runevent_result.html")
    )

    status = TenHsServer::Event.run "All on"
    assert_equal true, status
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