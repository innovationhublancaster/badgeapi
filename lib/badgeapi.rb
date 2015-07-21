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

	if ENV['RAILS_ENV'] == "production"
		@api_base = 'http://badgeapi.lancaster.ac.uk/v1'
	else
		puts "DEVELOPMENT"
		@api_base = 'http://gamification-api.dev/v1'
	end



	class << self
		attr_accessor :api_key, :api_base
	end

	def self.api_url
		@api_base
	end

	def self.api_key
		@api_key
	end

end
