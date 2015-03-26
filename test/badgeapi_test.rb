#test/badge/badge_test.rb
require './test/test_helper'

class BadgeapiTest < MiniTest::Test

	def test_api_url
		assert_equal Badgeapi.api_url, 'http://gamification-api.dev'
	end

	def test_api_key
		Badgeapi.api_key = 'foo'
		assert_equal Badgeapi.api_key, 'foo'
	end

	def test_bad_api_key
		VCR.use_cassette('bad_api_key') do
			Badgeapi.api_key= 'foo'
			assert_raises(Exception) { Badgeapi::Badge.all }
		end
	end

end
