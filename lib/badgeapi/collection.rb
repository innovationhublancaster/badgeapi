#lib/badgeapi/collection.rb

module Badgeapi
	class Collection < BadgeapiObject

		attr_reader :id, :created_at, :updated_at, :badges, :total_points_available
		attr_accessor :name, :description

	end
end