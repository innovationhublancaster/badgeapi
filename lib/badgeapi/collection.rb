#lib/badgeapi/collection.rb
require 'faraday'
require 'json'

API_URL = "http://gamification-api.dev"
BADGE_API_KEY = "c7f19faeb9514cfbbf3ecc8b71486366"

module Badgeapi
	class Collection

		attr_reader :id, :name, :description, :created_at, :updated_at

		def initialize(attributes)
			@id = attributes["id"]
			@name = attributes["name"]
			@description = attributes["description"]
			@created_at = attributes["created_at"]
			@updated_at = attributes["updated_at"]
		end

		def self.find(id)
			connection = Faraday.new()
			connection.token_auth(BADGE_API_KEY)
			response = connection.get("#{API_URL}/collections/#{id}.json")
			attributes = JSON.parse(response.body)
			new(attributes)
		end

		def self.all
			connection = Faraday.new()
			connection.token_auth(BADGE_API_KEY)
			response = connection.get("#{API_URL}/collections.json")
			attributes = JSON.parse(response.body)
			attributes.map { |attributes| new(attributes) }
		end

	end
end