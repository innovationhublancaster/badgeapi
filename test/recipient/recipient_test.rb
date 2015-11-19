#test/collection/collection_test.rb
require './test/test_helper'

class BadgeapiCollectionTest < MiniTest::Test

	Badgeapi.api_base = 'https://gamification-api.dev/v1'
	Badgeapi.ssl_ca_cert='/Users/tomskarbek/.tunnelss/ca/cert.pem'
	Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

	def self.test_order
		:alpha
	end

	def test_exists
		assert Badgeapi::Recipient
	end

	def test_object_path
		assert_equal "recipients", Badgeapi::Recipient.collection_path
	end

	def test_object_name
		assert_equal "recipient", Badgeapi::Recipient.member_name
	end

	def test_it_return_back_recipient_stats
		VCR.use_cassette('recipient_with_badges') do

			recipient = Badgeapi::Recipient.find(recipient: "t.skarbek-wazynski@lancaster.ac.uk")

			assert_equal recipient.class, Badgeapi::Recipient

			assert_kind_of Integer, recipient.total_score
			assert_kind_of Integer, recipient.badges_total
			assert_kind_of Integer, recipient.bronze_count
			assert_kind_of Integer, recipient.silver_count
			assert_kind_of Integer, recipient.gold_count
			assert_kind_of Integer, recipient.platinum_count

			assert_equal Array, recipient.badges.class
		end
	end

	def test_it_return_back_recipient_stats_with_unicard
		VCR.use_cassette('recipient_with_badges_unicard') do
			recipient = Badgeapi::Recipient.find(user: "0043181")

			assert_equal recipient.class, Badgeapi::Recipient

			assert_kind_of Integer, recipient.total_score
			assert_kind_of Integer, recipient.badges_total
			assert_kind_of Integer, recipient.bronze_count
			assert_kind_of Integer, recipient.silver_count
			assert_kind_of Integer, recipient.gold_count
			assert_kind_of Integer, recipient.platinum_count

			assert_equal Array, recipient.badges.class
		end
	end

	def test_it_raise_issue_if_bad_user
		VCR.use_cassette('recipient_bad_user_data') do

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Recipient.find(user: "dfsgsdgg") }

			begin
				Badgeapi::Recipient.find(user: "dfsgsdgg")
			rescue Badgeapi::InvalidRequestError => e
				assert_equal(404, e.http_status)
				refute_empty e.message
				assert_equal(true, e.json_body.kind_of?(Hash))
			end
		end
	end

	def test_you_cannot_request_any_other_function_on_recipients
		VCR.use_cassette('recipient_other_request') do

			assert_raises(NoMethodError) { Badgeapi::Recipient.all }

			assert_raises(NoMethodError) { Badgeapi::Recipient.find(1) }

			assert_raises(NoMethodError) { Badgeapi::Recipient.create(1) }

			assert_raises(NoMethodError) { Badgeapi::Recipient.update(1) }

			assert_raises(NoMethodError) { Badgeapi::Recipient.destroy(1) }
		end
	end
end
