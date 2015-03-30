#lib/badgeapi/badge.rb
module Badgeapi
	class Badge < BadgeapiObject

		define_attribute_methods %w(
			id
		 	name
		 	description
		 	requirements
		 	hint
		 	image
		 	recipient_id
		 	collection_id
			issuer_id
		 	issued_at
		 	created_at
		 	updated_at
		)

		def self.find(id)
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)
			response = connection.get "#{Badgeapi.api_url}/badges/#{id}"
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

			response = connection.get "#{Badgeapi.api_url}/badges", params

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

			response = connection.post "#{Badgeapi.api_url}/badges", {badge: params}

			attributes = JSON.parse(response.body)

			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				from_response(attributes)
			end
		end

		def self.save params={}

		end

		def self.destroy(id)
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)

			response = connection.delete "#{Badgeapi.api_url}/badges/#{id}"

			attributes = JSON.parse(response.body)

			if attributes.include?("error")
				raise Exception.new(attributes['error'])
			else
				from_response(attributes)
			end
		end

	end
end