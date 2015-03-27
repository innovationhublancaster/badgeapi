#test/badge/badge_test.rb
require './test/test_helper'

class BadgeapiBadgeTest < MiniTest::Test


	def test_exists
		assert Badgeapi::Badge
	end

	def test_it_returns_back_a_single_badge
		VCR.use_cassette('one_badge') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"

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

	def test_it_returns_back_all_badges
		VCR.use_cassette('all_badges') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"
			result = Badgeapi::Badge.all

			# Make sure we got all the badges
			assert_equal 6, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_it_returns_back_all_badges_from_collection
		VCR.use_cassette('all_badges_from_collection') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"
			result = Badgeapi::Badge.all(collection_id: 2)

			# Make sure we got all the badges
			assert_equal 2, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_all_limit
		VCR.use_cassette('all_badges_limited') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"
			result = Badgeapi::Badge.all(limit: 1)

			# Make sure we got all the badges
			assert_equal 1, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_badges_raise_errors
		VCR.use_cassette('badge_error') do
			Badgeapi.api_key= 'c1616687d0fc420d85c8590357d1ab29'
			assert_raises(Exception) { Badgeapi::Badge.find(27) }
		end
	end
end