#lib/badgeapi/badge.rb
require 'faraday'
require 'json'

API_URL = "http://gamification-api.dev"
BADGE_API_KEY = "c7f19faeb9514cfbbf3ecc8b71486366"

module Badgeapi
	class Badge

		attr_reader :id, :name, :description, :requirements, :hint, :image, :recipient_id, :issuer_id, :collection_id, :issued_at, :created_at, :updated_at

		def initialize(attributes)
			@id = attributes["id"]
			@name = attributes["name"]
			@description = attributes["description"]
			@requirements = attributes["requirements"]
			@hint = attributes["hint"]
			@image = attributes["image"]
			@recipient_id = attributes["recipient_id"]
			@collection_id = attributes["collection_id"]
			@issued_at = attributes["issued_at"]
			@created_at = attributes["created_at"]
			@updated_at = attributes["updated_at"]
		end

		def self.find(id)
			connection = Faraday.new()
			connection.token_auth(BADGE_API_KEY)
			response = connection.get("#{API_URL}/badges/#{id}.json")
			attributes = JSON.parse(response.body)
			new(attributes)
		end

		def self.all
			connection = Faraday.new()
			connection.token_auth(BADGE_API_KEY)
			response = connection.get("#{API_URL}/badges.json")
			attributes = JSON.parse(response.body)
			attributes.map { |attributes| new(attributes) }
		end

	end
end