#lib/badgeapi/badgeapi_object.rb

module Badgeapi
	class BadgeapiObject
		class << self

			def collection_name
				name.demodulize.pluralize.underscore
			end
			alias collection_path collection_name

			def member_name
				name.demodulize.underscore
			end

			def initialize attributes = {}
				if instance_of? BadgeapiObject
					raise Error,
						  "#{self.class} is an abstract class and cannot be instantiated"
				end

				self.attributes = attributes
				yield self if block_given?
			end

			def from_response attributes
				record = new
				attributes.each do |name, value|
					record.instance_variable_set "@#{name}", value
				end
				record
			end

			def find(id)
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)
				response = connection.get "#{Badgeapi.api_url}/#{collection_path}/#{id}"
				attributes = JSON.parse(response.body)
				if attributes.include?("error")
					raise Exception.new(attributes['error'])
				else
					from_response(attributes)
				end
			end

			def all params = {}
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				response = connection.get "#{Badgeapi.api_url}/#{collection_path}", params

				attributes = JSON.parse(response.body)
				if attributes.include?("error")
					raise Exception.new(attributes['error'])
				else
					attributes.map { |attributes| from_response(attributes) }
				end
			end

			def create params={}
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				response = connection.post "#{Badgeapi.api_url}/#{collection_path}", member_name => params

				attributes = JSON.parse(response.body)

				if attributes.include?("error")
					raise Exception.new(attributes['error'])
				else
					from_response(attributes)
				end
			end

			def save params={}

			end

			def destroy(id)
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				response = connection.delete "#{Badgeapi.api_url}/#{collection_path}/#{id}"

				attributes = JSON.parse(response.body)

				if attributes.include?("error")
					raise Exception.new(attributes['error'])
				else
					from_response(attributes)
				end
			end

		end
	end
end