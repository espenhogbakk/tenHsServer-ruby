# This is a ruby wrapper around the tenHsServer Homeseer API
#
# Author: Espen Høgbakk
# Email: espen@hogbakk.no

require "ten_hs_server/version"

module TenHsServer
  def self.new host
    @host = host
    self
  end

  def self.host
    @host
  end

  autoload :Adapter, "ten_hs_server/adapter"
  autoload :Device, "ten_hs_server/device"
  autoload :Event, "ten_hs_server/event"
  autoload :Room, "ten_hs_server/room"

  def self.event
    return TenHsServer::Event
  end

  def self.device
    return TenHsServer::Device
  end

  def self.room
    return TenHsServer::Room
  end

end