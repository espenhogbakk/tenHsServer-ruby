require 'nokogiri'

module TenHsServer

  # Adapter for TenHsServer devices endpoint, which returns information
  # for each of the devices in Homeseer
  class Device < Adapter

    # Load all devices.
    #
    # Returns an array of hashes describing each device.
    def self.all deep=false
      response = get "?t=99&f=GetDevices"
      devices = parse_devices response.body

      if deep
        devices.map! do |device|
          find device[:id]
        end
      end

      devices
    end

    # Load a single device.
    #
    # id - An string describing the device
    #
    # Returns a hash describing the device.
    def self.find id
      response = get "?t=99&f=GetDevice&d=#{id}"

      parse_device response.body
    end

    private

    # Parse the GetDevices response.
    #
    # response - A string describing the response.
    def self.parse_devices response
      doc = Nokogiri::HTML(response)
      result = doc.xpath('//span[@id="Result"]')[0].content
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
      doc = Nokogiri::HTML(response)
      result = doc.xpath('//span[@id="Result"]')[0].content
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
          status: values[7],
          value: values[8],
          string: values[9],
          time: values[10],
          last_change: values[11],
          misc: values[4]
        }
      end
      results[0]
    end

  end
end