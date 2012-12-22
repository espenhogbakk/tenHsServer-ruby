# This is a ruby wrapper around the tenHsServer Homeseer API
#
# Author: Espen Høgbakk
# Email: espen@hogbakk.no

require "ten_hs_server/version"

module TenHsServer
  autoload :Adapter, "ten_hs_server/adapter"
  autoload :Device, "ten_hs_server/device"
  autoload :Event, "ten_hs_server/event"
  autoload :Room, "ten_hs_server/room"
end