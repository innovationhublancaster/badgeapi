require 'active_support/all'
require 'faraday'
require 'json'

require_relative "badgeapi/badgeapi_object"
require_relative "badgeapi/version"
require_relative "badgeapi/badge"
require_relative "badgeapi/collection"
require_relative "badgeapi/recipient"

# Errors
require_relative "badgeapi/errors/badgeapi_error"
require_relative "badgeapi/errors/api_error"
require_relative "badgeapi/errors/invalid_request_error"

module Badgeapi
  @api_base = 'https://badgeapi.lancaster.ac.uk/v1'

  class << self
    attr_accessor :api_key, :api_base, :ssl_ca_cert
  end

  def self.api_url
    @api_base
  end

  def self.api_key
    @api_key
  end

  def self.ssl_ca_cert
    @ssl_ca_cert
  end
end
