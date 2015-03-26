#lib/badgeapi/configuration.rb

module Badgeapi
	module Configuration
		@api_base = 'http://gamification-api.dev'
		@api_key

		attr_accessor :api_key, :api_base

		def configure
			yield self
		end

		def self.api_url
			@api_base
		end

		def initialize(api_key='')
			@api_key = api_key
		end
	end
end