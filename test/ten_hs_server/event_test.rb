require 'test_helper'
require "active_support/all"
require 'ten_hs_server'

class EventTest < ActiveSupport::TestCase
  setup do
    TenHsServer::Event.expects(:get).with(
      "?t=99&f=GetEvents",
    ).returns(
      stub body: fixture("events_result.html")
    )
  end

  test "should load all events" do
    events = TenHsServer::Event.all

    assert_equal 8, events.count
  end

  test "should load a single event" do
    event = TenHsServer::Event.find 0
    assert_equal "All on", event[:name]
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