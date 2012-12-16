module TenHsServer

  # Adapter for TenHsServer devices endpoint, which returns information
  # for each of the devices in Homeseer
  class Device < Adapter
    attr_reader :id, :_name, :_type, :_room, :_floor

    def initialize id, name=nil, type=nil, room=nil, floor=nil
      @id = id
      @_name = name
      @_type = type
      @_room = room
      @_floor = floor
    end

    def query
      @query || @query = self.class.find(id)
    end

    # Methods
    def toggle
      self.class.toggle(id)
    end

    def on
      self.class.on(id)
    end

    def off
      self.class.off(id)
    end

    def dim value
      if value == 0
        off
      else
        on
        self.class.value(id, value)
      end
    end

    # Properties
    def on?
      true ? query[:status] == 2 : false
    end

    def off?
      true ? query[:status] == 3 : false
    end

    def type
      _type ? _type : query[:type]
    end

    def room
      _room ? _room : query[:location]
    end

    def name
      _name ? _name : query[:name]
    end

    def floor
      _floor ? _floor : query[:floor]
    end

    def dimmable
      # Boolean that
      query[:dim]
    end

    def status
      # Status of device
      # 2 On
      # 3 Off
      # 4 Dimmed
      query[:status]
    end

    def value
      # For dimmable devices this is a value between 0 and 100
      query[:value]
    end

    # All inside are class methods
    class << self
      # Load all devices.
      #
      # Returns an array of Device instances.
      def all
        response = get "?t=99&f=GetDevices"
        devices = parse_devices response.body

        devices.map! do |device|
          new(device[:id], device[:name], device[:type], device[:location], device[:floor])
        end

        devices
      end

      # Load a single device.
      #
      # id - An string describing the device
      #
      # Returns a hash describing the device.
      def find id
        response = get "?t=99&f=GetDevice&d=#{id}"

        parse_device response.body
      end

      # Toggle a device.
      #
      # id - An string describing the device
      #
      # Returns a true or false describing the status of the device
      # false = off
      # true = on
      def toggle id
        response = get "?t=99&f=ToggleDevice&d=#{id}"

        parse_toggle_device response.body
      end

      # Turn on a device.
      #
      # id - An string describing the device
      #
      # Returns a true or false describing the status of the device
      # false = off
      # true = on
      def on id
        response = get "?t=99&f=DeviceOn&d=#{id}"

        parse_toggle_device response.body
      end

      # Turn off a device.
      #
      # id - An string describing the device
      #
      # Returns a true or false describing the status of the device
      # false = off
      # true = on
      def off id
        response = get "?t=99&f=DeviceOff&d=#{id}"

        parse_toggle_device response.body
      end

      # Set device value.
      #
      # id - An string describing the device
      # value - The value to give the device
      #
      def value(id, value)
        response = get "?t=99&f=SetDeviceValue&d=#{id}&a=#{value}"

        parse_set_device_value response.body
      end

    end

    private

    # Parse the GetDevices response.
    #
    # Response contains multiple device strings, one for each device, separated by ";" 
    # Each device string is formatted as:
    #
    # DeviceCode:DeviceType:Location:Name:Location2
    #
    # An example if only two devices were defined in Homeseer:
    # a1:Lamp Module:Kitchen:Counter Pucks:loc2;a2:Applicance Module:Den:Ceiling Light:Loc2;
    #
    # response - A string describing the response.
    def self.parse_devices response
      result = parse response
      results = result.split(";")

      results.map do |item|
        # DeviceCode:DeviceType:Location:Name:Location2
        values = item.split(":")
        {
          id: values[0],
          type: values[1],
          location: values[2],
          name: values[3],
          floor: values[4],
        }
      end
    end

    # Parse the GetDevice response.
    # 
    # Response contains the device fields in the form: 
    # d:loc:name:type:misc:loc2:dim:status:value:string:time:LastChange
    #
    # 0: d=device code
    # 1: loc=location
    # 2: name=device name
    # 3: type=device type
    # 4: misc=misc binary field
    # 5: loc2=location 2
    # 6: dim=can dim
    # 7: status=device status
    # 8: value=device value
    # 9: string= encoded DeviceString (see DeviceString) 
    # 10: time=device time (in minutes) 
    # 11: LastChange=device LastChange date/time
    #
    # response - A string describing the response.
    def self.parse_device response
      result = parse response
      results = result.split(";")

      results.map! do |item|
        values = item.split(":")
        {
          id: values[0],
          type: values[3],
          location: values[1],
          name: values[2],
          floor: values[5],
          dim: values[6],
          status: values[7].to_i,
          value: values[8],
          string: values[9],
          time: values[10],
          last_change: values[11],
          misc: values[4]
        }
      end

      if results.length > 1
        raise MultipleFoundError
      else
        if results[0][:location] == 'Device Not Found'
          raise NotFoundError
        else
          results[0]
        end
      end
    end

    # Parse the ToggleDevice response.
    # 
    # Response contains a list of the devices and their new status
    # Q12:2;Q10:3
    #
    # Where device Q12 is on, and Q10 is off
    #
    # response - A string describing the response.
    def self.parse_toggle_device response
      result = parse response
      results = result.split(";")

      results.map! do |item|
        values = item.split(":")
        {
          id: values[0],
          status: values[1].to_i,
        }
      end
      results[0]
    end

    # Parse the SetDeviceValue response.
    # 
    # Response contains the new value of the device
    #
    # response - A string describing the response.
    def self.parse_set_device_value response
      result = parse response
      result.to_i
    end

  end
end