#lib/badgeapi/collection.rb

module Badgeapi
	class Collection < BadgeapiObject

		attr_reader :id, :created_at, :updated_at, :badges, :total_points_available, :object, :badge_count
		attr_accessor :name, :description

	end
end