require 'httparty'
require 'nokogiri'
require 'open-uri'

module TenHsServer

  # Base class for TenHsServer adapters.
  class Adapter
    include HTTParty

    base_uri "10.0.0.71/tenHsServer/tenHsServer.aspx"

    private

    # Parse the tenHsServer response.
    #
    # tenHsServer returns the results in a <span> element with
    # the id "Result". So we parses the html and returns the
    # string inside the span
    #
    # response - A string describing the response.
    def self.parse response
      doc = Nokogiri::HTML(response)
      doc.xpath('//span[@id="Result"]')[0].content
    end

  end

  class Error < StandardError; end
  class NotFoundError < StandardError; end
  class MultipleFoundError < StandardError; end
end