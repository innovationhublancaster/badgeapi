# lib/badgeapi/badgeapi_object.rb
module Badgeapi
  class BadgeapiObject
    class << self
      def collection_name
        name.demodulize.pluralize.underscore
      end
      alias_method :collection_path, :collection_name

      def member_name
        name.demodulize.underscore
      end

      def request method, url, params = {}
        connection = Faraday.new(ssl: { ca_file: Badgeapi.ssl_ca_cert })

        connection.token_auth(Badgeapi.api_key)
        from_response connection.send(method, url, params)
      end

      def from_response response
        attributes = JSON.parse(response.body)

        if attributes.include?("error")
          handle_api_error attributes
        else
          if attributes.class == Array
            attributes.map do |subattributes|
              map_json_to_object(subattributes)
            end
          else
            map_json_to_object attributes
          end
        end
      end

      def object_classes
        @object_classes ||= {
          'recipient'      => Recipient,
          'collection'     => Collection,
          'badge'          => Badge,
          'required_badge' =>	Badge
        }
      end

      def map_json_to_object attributes
        if attributes['object'].nil?
          record = new
        else
          record = object_classes.fetch(attributes['object'].singularize).new
        end

        map_instant_variables_to_record attributes, record
        record
      end

      def map_instant_variables_to_record attributes, record
        attributes.each do |name, value|
          if attribute_a_badge_object? name
            child = map_related_object object_classes.fetch(name.singularize), value
            record.instance_variable_set "@#{name}", child
          else
            record.instance_variable_set "@#{name}", value
          end
        end
      end

      def map_related_object object, attributes
        if attributes.class == Array
          attributes.map do |subattributes|
            # Recursion: loop through until every object is mapped
            map_related_object object, subattributes
          end
        else
          record = object.new
          map_instant_variables_to_child_records attributes, record
          record
        end
      end

      def map_instant_variables_to_child_records attributes, record
        attributes.each do |name, value|
          if value.class == Array && value.count > 0
            if attribute_a_badge_object? name
              child = map_related_object object_classes.fetch(name.singularize), value
              record.instance_variable_set "@#{name}", child
            end
          else
            record.instance_variable_set "@#{name}", value
          end
        end
      end

      def attribute_a_badge_object? name
        if object_classes.has_key?(name) || object_classes.has_key?(name.singularize)
          true
        else
          false
        end
      end

      def find id, params = {}
        request "get", "#{Badgeapi.api_url}/#{collection_path}/#{id}", params
      end

      def all params = {}
        request "get", "#{Badgeapi.api_url}/#{collection_path}", params
      end

      def create params = {}
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
      id_as_string = (respond_to?(:id) && !id.nil?) ? " id=#{id}" : ""
      "#<#{self.class}:0x#{object_id.to_s(16)}#{id_as_string}> JSON: " + to_json
    end

    def remove_read_only_params
      # Remove params that cannot be saved as they are not permitted through strong_params on api
      params = JSON.parse(to_json)

      params.delete("id")
      params.delete("created_at")
      params.delete("updated_at")
      params.delete("points")
      params.delete("total_points_available")
      params.delete("badge_count")
      params.delete("object")
    end

    def save
      # Remove params that cannot be saved as they are not permitted through strong_params on api
      params = remove_read_only_params

      self.class.request "patch", "#{Badgeapi.api_url}/#{self.class.collection_path}/#{id}",
                         self.class.member_name => params
    end

    def self.handle_api_error error
      error_object = error['error']

      case error_object["type"]
      when "invalid_request_error"
        raise InvalidRequestError.new(error_object["message"], error_object["status"], error)
      when "api_error"
        raise APIError.new(error_object["message"], error_object["status"], error)
      else
        raise APIError.new("Unknown error tyep #{error_object['type']}", error_object["status"], error)
      end
    end
  end
end
