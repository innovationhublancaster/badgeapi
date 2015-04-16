#lib/badgeapi/badge.rb
module Badgeapi
	class Badge < BadgeapiObject

		attr_reader :id, :created_at, :updated_at, :collection, :image_greyscale
		attr_accessor :name, :description, :requirements, :requirements, :hint, :image, :recipient_id, :collection_id, :issuer_id, :issued_at

	end
end