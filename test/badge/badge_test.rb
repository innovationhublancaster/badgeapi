#test/badge/badge_test.rb
require './test/test_helper'

class BadgeapiBadgeTest < MiniTest::Test


	def test_exists
		assert Badgeapi::Badge
	end

	def test_api_url
		assert_equal Badgeapi.api_url, 'http://gamification-api.dev'
	end

	def test_api_key
		Badgeapi.api_key = 'foo'
		assert_equal Badgeapi.api_key, 'foo'
	end

	def test_it_returns_back_a_single_badge
		VCR.use_cassette('one_badge') do
			Badgeapi.api_key = "c7f19faeb9514cfbbf3ecc8b71486366"

			badge = Badgeapi::Badge.find(1)
			assert_equal Badgeapi::Badge, badge.class

			assert_equal 1, badge.id
			assert_equal "Book Worm", badge.name
			assert_equal "Description?", badge.description
			assert_equal "Loan out 25 books", badge.requirements
			assert_equal "You must like books...", badge.hint
			assert_equal "http://openbadges.org/wp-content/themes/openbadges2/media/images/content-background.png", badge.image
			assert_equal 1, badge.collection_id
		end
	end

	def test_it_returns_back_a_all_badges
		VCR.use_cassette('all_badges') do
			Badgeapi.api_key = "c7f19faeb9514cfbbf3ecc8b71486366"
			result = Badgeapi::Badge.all

			# Make sure we got all the badges
			assert_equal 4, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end
end