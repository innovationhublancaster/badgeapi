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

			def from_response response
				attributes = JSON.parse(response.body)

				if attributes.include?("error")
					raise Exception.new(attributes['error'])
				else
					if attributes.class == Array
						attributes.map { |attributes| map_json_to_object(attributes) }
					else
						map_json_to_object attributes
					end
				end
			end

			def map_json_to_object attributes
				record = new
				attributes.each do |name, value|
					record.instance_variable_set "@#{name}", value
				end
				record
			end

			def find(id)
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)
				from_response connection.get "#{Badgeapi.api_url}/#{collection_path}/#{id}"
			end

			def all params = {}
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				from_response connection.get "#{Badgeapi.api_url}/#{collection_path}", params

				# attributes = JSON.parse(response.body)
				#
				# if attributes.include?("error")
				# 	raise Exception.new(attributes['error'])
				# else
				# 	attributes.map { |attributes| map_json_to_object(attributes) }
				# end
			end

			def create params={}
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				from_response connection.post "#{Badgeapi.api_url}/#{collection_path}", member_name => params
			end

			def save
				abort('here')
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				from_response connection.patch "#{Badgeapi.api_url}/#{collection_path}/#{id}", to_json
			end

			def destroy(id)
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)

				from_response connection.delete "#{Badgeapi.api_url}/#{collection_path}/#{id}"
			end
		end

		def except(*keys)
			abort "here"
			dup.except!(*keys)
		end

		def except!(*keys)
			keys.each { |key| delete(key) }
			self
		end

		def save
			connection = Faraday.new()
			connection.token_auth(Badgeapi.api_key)

			params = JSON.parse(self.to_json)
			params.delete("id")
			params.delete("created_at")
			params.delete("updated_at")

			self.class.from_response connection.patch "#{Badgeapi.api_url}/#{self.class.collection_path}/#{id}", self.class.member_name => params
		end
	end
end