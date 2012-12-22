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

      parse_events response.body
    end

    # Load a single event.
    #
    # name - An string describing the event
    #
    # Returns the name of the event
    def self.find name
      all.find { |event| event == name }
    end

    # Run an event.
    #
    # name - An string describing the event
    #
    # Returns a bool describing if the event was run or not
    def self.run name
      name = URI::encode(name)
      response = get "?t=99&f=RunEvent&d=All%20on"
      
      parse_runevent response.body
    end

    private

    # Parse the GetEvents response.
    #
    # Response contains multiple events, separated by ";" 
    # Event1;Event2;Eventn;
    #
    # response - A string describing the response.
    def self.parse_events response
      result = parse response
      results = result.split(";")

      results.map do |item|
        item
      end
    end

    # Parse the RunEvent response.
    #
    # Response contains either 1 or 0
    # 1 = event was run
    # 0 = event failed to run
    # 
    # response - A string describing the response.
    def self.parse_runevent response
      result = parse response

      if result == "1"
        true
      else
        false
      end

    end

  end
end