#lib/badgeapi/collection.rb
require 'faraday'
require 'json'

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
			connection.token_auth(Badgeapi.api_key)
			response = connection.get "#{Badgeapi.api_url}/collections/#{id}.json"
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
			response = connection.get "#{Badgeapi.api_url}/collections.json", params
			attributes = JSON.parse(response.body)
			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				attributes.map { |attributes| new(attributes) }
			end
		end

	end
end