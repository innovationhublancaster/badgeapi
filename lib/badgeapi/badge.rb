#lib/badgeapi/badge.rb
require 'faraday'
require 'json'

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
			connection.token_auth(Badgeapi.api_key)
			response = connection.get "#{Badgeapi.api_url}/badges/#{id}"
			attributes = JSON.parse(response.body)
			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				new(attributes)
			end
		end

		def self.all params = {}
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)
			response = connection.get "#{Badgeapi.api_url}/badges", params
			attributes = JSON.parse(response.body)
			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				attributes.map { |attributes| new(attributes) }
			end
		end

	end
end