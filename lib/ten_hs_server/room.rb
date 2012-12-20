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
      status = self.class.on(devices)
      true
    end

    def off
      status = self.class.off(devices)
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
          floor: devices_in_room.any? ? devices_in_room[0].floor : nil,
          devices: devices_in_room
        }

      end

      # Turn on all devices in this room.
      #
      # devices - An array with devices
      def on devices
        ids = devices.map { |device| device.id }
        ids = ids.join(".")
        response = get "?t=99&f=DeviceOn&d=#{ids}"

        parse_toggle_devices response.body
      end

      # Turn off a device.
      #
      # id - An string describing the device
      #
      # Returns a true or false describing the status of the device
      # false = off
      # true = on
      def off devices
        ids = devices.map { |device| device.id }
        ids = ids.join(".")
        response = get "?t=99&f=DeviceOff&d=#{ids}"

        parse_toggle_devices response.body
      end

    end

    private

    # Parse the ToggleDevice response.
    # 
    # Response contains a list of the devices and their new status
    # Q12:2;Q10:3
    #
    # Where device Q12 is on, and Q10 is off
    #
    # response - A string describing the response.
    def self.parse_toggle_devices response
      result = parse response
      results = result.split(";")

      results.map! do |item|
        values = item.split(":")
        {
          id: values[0],
          status: values[1].to_i,
        }
      end
      results
    end

  end
end