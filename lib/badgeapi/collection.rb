#lib/badgeapi/collection.rb

module Badgeapi
	class Collection < BadgeapiObject

		attr_reader :id, :created_at, :updated_at
		attr_accessor :name, :description

		@url_method = "collections"

	end
end