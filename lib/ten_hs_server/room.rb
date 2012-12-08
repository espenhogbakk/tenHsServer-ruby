module TenHsServer

  # Adapter for working with Homeseer rooms, tenHsServer has no endpoint for fetching
  # rooms, so we need to get that from device metadata.
  class Room < Adapter
    attr_accessor :name

    def initialize name
      @name = name
    end

    def query
      @query || @query = self.class.find(name)
    end

    def devices
      query[:devices]
    end

    def floor
      query[:floor]
    end

    def on
      devices.each do |device|
        device.on
      end
      
      true
    end

    def off
      devices.each do |device|
        device.off
      end
      
      true
    end

    # All inside are class methods
    class << self
      # Load all rooms.
      #
      # Returns an array of Room's.
      def all
        devices = Device.all
        rooms = []

        # Go through each device, check which room it belongs
        # do, if the room doesn't exist, add it to rooms
        devices.each do |device|
          unless rooms.find {|room| room.name == device.room}
            rooms << new(device.room)
          end
        end

        rooms
      end

      # Load a single room.
      #
      # Returns a hash describing the room.
      def find name
        devices = Device.all
        devices_in_room = []

        # Go through each device, check which room it belongs too.
        # If the device belongs to this room, add it to devices_in_room
        devices.each do |device|
          if device.room == name
            devices_in_room << device
          end
        end
        
        {
          name: name,
          floor: devices_in_room[0].floor,
          devices: devices_in_room
        }

      end

    end

  end
end