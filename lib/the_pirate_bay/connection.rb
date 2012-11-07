require "faraday"

module ThePirateBay
  module Connection
    extend self
    
    @connection = nil
    
    def connection
      @connection ||= Faraday.new(:url => ThePirateBay::ENDPOINT) do |faraday|
        faraday.response :logger if ENV['DEBUG'] # log requests to STDOUT
        faraday.adapter  :net_http # make requests with NetHTTP
      end
    end
    
    def request(path, params={})
      response = connection.get(path, params)
      response.body
    end
    
  end # Connection
end # ThePirateBay