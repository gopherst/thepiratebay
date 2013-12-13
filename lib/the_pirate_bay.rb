require "the_pirate_bay/core_ext/string"
require "the_pirate_bay/errors"
require "the_pirate_bay/version"
require "the_pirate_bay/api"
require "the_pirate_bay/model"
require "the_pirate_bay/client"

module ThePirateBay

  ENDPOINT = "http://thepiratebay.pe".freeze

  class << self

    # Handle for the client instance
    attr_accessor :api_client

    def new(options={}, &block)
      @api_client = ThePirateBay::Client.new(options, &block)
    end

    # Delegate to ThePirateBay::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end

  end # Self
end # ThePirateBay
