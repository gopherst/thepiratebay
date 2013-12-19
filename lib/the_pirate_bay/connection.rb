require "faraday"
require "faraday_middleware"
require "the_pirate_bay/response"
require "the_pirate_bay/response/htmlize"

module ThePirateBay
  module Connection
    extend self

    @connection = nil

    def connection
      @connection ||= Faraday.new(:url => ThePirateBay::ENDPOINT) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects, limit: 5 # TPB is moving a lot
        faraday.response :logger if ENV['DEBUG'] # log requests to STDOUT
        faraday.adapter :net_http # make requests with NetHTTP
        faraday.use ThePirateBay::Response::Htmlize
      end
    end

    def request(path, params={})
      response = connection.get(path, params)
      response.body
    end

  end # Connection
end # ThePirateBay
