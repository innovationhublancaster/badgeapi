require 'active_support/all'
require 'faraday'
require 'json'

require_relative "badgeapi/badgeapi_object"
require_relative "badgeapi/version"
require_relative "badgeapi/badge"
require_relative "badgeapi/collection"

# Errors
require_relative "badgeapi/errors/badgeapi_error"
require_relative "badgeapi/errors/api_error"
require_relative "badgeapi/errors/invalid_request_error"

module Badgeapi

	@api_base = 'http://gamification-api.dev/v1'

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
