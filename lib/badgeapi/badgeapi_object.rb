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

			def request method, url, params={}
				connection = Faraday.new()
				connection.token_auth(Badgeapi.api_key)
				from_response connection.send(method, url, params)
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
				request "get", "#{Badgeapi.api_url}/#{collection_path}/#{id}"
			end

			def all params = {}
				request "get", "#{Badgeapi.api_url}/#{collection_path}", params
			end

			def create params={}
				request "post", "#{Badgeapi.api_url}/#{collection_path}", member_name => params
			end

			def update id, params = {}
				request "patch", "#{Badgeapi.api_url}/#{collection_path}/#{id}", member_name => params
			end

			def destroy(id)
				request "delete", "#{Badgeapi.api_url}/#{collection_path}/#{id}"
			end
		end

		def inspect
			id_as_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
			"#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_as_string}> JSON: " + self.to_json
		end

		def save
			# Remove params that cannot be saved as they are not permitted through strong_params on api
			params = JSON.parse(self.to_json)

			params.delete("id")
			params.delete("created_at")
			params.delete("updated_at")

			self.class.request "patch", "#{Badgeapi.api_url}/#{self.class.collection_path}/#{id}", self.class.member_name => params
		end
	end
end