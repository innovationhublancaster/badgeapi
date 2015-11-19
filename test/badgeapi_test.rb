#test/badge/badge_test.rb
require './test/test_helper'

class BadgeapiTest < MiniTest::Test

	Badgeapi.api_base = 'https://gamification-api.dev/v1'
	Badgeapi.ssl_ca_cert='/Users/tomskarbek/.tunnelss/ca/cert.pem'
	Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

	def test_api_url
		assert_equal Badgeapi.api_url, 'https://gamification-api.dev/v1'
	end

	def test_api_key
		Badgeapi.api_key = 'foo'
		assert_equal Badgeapi.api_key, 'foo'
	end

	def test_ssl_ca_cert
		Badgeapi.ssl_ca_cert = 'foo'
		assert_equal Badgeapi.ssl_ca_cert, 'foo'
	end

end
