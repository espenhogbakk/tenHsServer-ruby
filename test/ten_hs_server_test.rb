require 'test/unit'
require "active_support/all"

class TenHsServerTest < ActiveSupport::TestCase
  test "initializing the client" do
    client = TenHsServer.new '10.0.0.71'
    assert_equal "10.0.0.71", client.host
  end
end
