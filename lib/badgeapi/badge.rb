#lib/badgeapi/badge.rb
module Badgeapi
	class Badge < BadgeapiObject

		attr_reader :id, :created_at, :updated_at, :collection, :image_greyscale, :points
		attr_accessor :name, :description, :requirements, :requirements, :hint, :image, :recipient_id, :collection_id, :issuer_id, :issued_at, :level


		class << self

			def issue id, params = {}
				request "post", "#{Badgeapi.api_url}/#{collection_path}/#{id}/issue", params
			end

			def revoke id, params = {}
				request "post", "#{Badgeapi.api_url}/#{collection_path}/#{id}/revoke", params
			end

		end

	end
end