#lib/badgeapi/collection.rb

module Badgeapi
	class Recipient < BadgeapiObject

		attr_reader :total_score, :badges_total, :bronze_count, :silver_count, :gold_count, :platinum_count, :badges, :object

		class << self

			def find params = {}
				request "get", "#{Badgeapi.api_url}/#{collection_path}", params
			end

			undef_method :all, :create, :update, :destroy
		end

	end
end