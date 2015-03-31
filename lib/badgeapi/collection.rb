#lib/badgeapi/collection.rb

module Badgeapi
	class Collection < BadgeapiObject

		attr_reader :id, :created_at, :updated_at
		attr_accessor :name, :description

		def self.find(id)
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)
			response = connection.get "#{Badgeapi.api_url}/collections/#{id}.json"
			attributes = JSON.parse(response.body)
			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				from_response(attributes)
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
				attributes.map { |attributes| from_response(attributes) }
			end
		end

		def self.create params={}
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)

			response = connection.post "#{Badgeapi.api_url}/collections", {collection: params}

			attributes = JSON.parse(response.body)

			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				from_response(attributes)
			end
		end

		def self.destroy(id)
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)

			response = connection.delete "#{Badgeapi.api_url}/collections/#{id}"

			attributes = JSON.parse(response.body)

			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				from_response(attributes)
			end
		end

	end
end