require 'nokogiri'

module TenHsServer

  # Adapter for TenHsServer devices endpoint, which returns information
  # for each of the devices in Homeseer
  class Device < Adapter

    # Load all devices.
    #
    # Returns an array of hashes describing each device.
    def self.all
      response = get "?t=99&f=GetDevices"

      parse response.body
    end

    # Load a single device.
    #
    # id - An integer describing the device number.
    #
    # Returns a hash describing the store.
    def self.find id
      all.find { |s| s[:id] == id }
    end

    private

    # Parse the response.
    #
    # response - A string describing the response.
    def self.parse response
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
  end
end