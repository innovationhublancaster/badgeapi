#lib/badgeapi/badge.rb
module Badgeapi
	class Badge < BadgeapiObject

		attr_reader :id, :created_at, :updated_at, :collection, :image_greyscale, :points, :required_badges
		attr_accessor :name, :description, :requirements, :requirements, :hint, :image, :recipient_id, :collection_id, :issuer_id, :issued_at, :level


		class << self

			def issue id, params = {}
				request "post", "#{Badgeapi.api_url}/#{collection_path}/#{id}/issue", params
			end

			def revoke id, params = {}
				request "post", "#{Badgeapi.api_url}/#{collection_path}/#{id}/revoke", params
			end

			def add_badge_requirement id, required_id
				request "post", "#{Badgeapi.api_url}/#{collection_path}/#{id}/requires", {required_badge: {id: required_id}}
			end

			def remove_badge_requirement id, required_id
				request "delete", "#{Badgeapi.api_url}/#{collection_path}/#{id}/requires", {required_badge: {id: required_id}}
			end

		end
	end
end