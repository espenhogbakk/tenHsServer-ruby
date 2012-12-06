require 'nokogiri'

module TenHsServer

  # Adapter for TenHsServer events endpoint, which returns information
  # for each of the events in Homeseer
  class Event < Adapter

    # Load all events.
    #
    # Returns an array of hashes describing each event.
    def self.all deep=false
      response = get "?t=99&f=GetEvents"

      parse response.body
    end

    # Load a single event.
    #
    # id - An string describing the event
    #
    # Returns a hash describing the event.
    def self.find id
      all.find { |s| s[:id] == id }
    end

    private

    # Parse the GetEvents response.
    #
    # Response contains multiple events, separated by ";" 
    # Event1;Event2;Eventn;
    #
    # response - A string describing the response.
    def self.parse response
      doc = Nokogiri::HTML(response)
      result = doc.xpath('//span[@id="Result"]')[0].content
      results = result.split(";")
      
      results.each_with_index.map do |item, index|
        {
          id: index,
          name: item,
        }
      end
    end
  end
end