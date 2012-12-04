require 'httparty'

module TenHsServer

  # Base class for TenHsServer adapters.
  class Adapter
    include HTTParty

    base_uri "10.0.0.71/tenHsServer/tenHsServer.aspx"
  end

  class Error < StandardError; end
end