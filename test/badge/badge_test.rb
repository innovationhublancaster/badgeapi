#test/badge/badge_test.rb
require './test/test_helper'

class BadgeapiBadgeTest < MiniTest::Test

	Badgeapi.api_base = 'https://gamification-api.dev/v1'
	Badgeapi.ssl_ca_cert='/Users/tomskarbek/.tunnelss/ca/cert.pem'
	Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

	def self.test_order
		:alpha
	end

	def test_exists
		assert Badgeapi::Badge
	end

	def test_object_path
		assert_equal "badges", Badgeapi::Badge.collection_path
	end

	def test_object_name
		assert_equal "badge", Badgeapi::Badge.member_name
	end

	def test_it_returns_back_a_single_badge
		VCR.use_cassette('badge_one') do
			badge = Badgeapi::Badge.find(1)
			assert_equal Badgeapi::Badge, badge.class

			assert_kind_of String, badge.id
			assert_kind_of String, badge.name
			assert_kind_of String, badge.description
			assert_kind_of String, badge.requirements
			assert_kind_of String, badge.hint
			assert_kind_of String, badge.image
			assert_kind_of String, badge.collection_id
			assert_kind_of String, badge.level
			assert_kind_of Integer, badge.points
			assert_equal false, badge.auto_issue
			assert_kind_of String, badge.object
			assert_kind_of String, badge.status
		end
	end

	def test_it_returns_back_a_single_badge_expanded
		VCR.use_cassette('badge_one_expanded') do
			badge = Badgeapi::Badge.find(1, expand: "collection")
			assert_equal Badgeapi::Badge, badge.class

			assert_kind_of String, badge.id
			assert_kind_of String, badge.name
			assert_kind_of String, badge.description
			assert_kind_of String, badge.requirements
			assert_kind_of String, badge.hint
			assert_kind_of String, badge.image
			assert_kind_of String, badge.collection_id

			assert_equal Badgeapi::Collection, badge.collection.class
			assert_kind_of String, badge.collection.name
		end
	end

	def test_it_returns_back_all_badges_issued_to_user
		VCR.use_cassette('badge_all_issued') do
			result = Badgeapi::Badge.all(user: "t.skarbek-wazynski@lancaster.ac.uk")

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)

			result = Badgeapi::Badge.all(user: "0043181") #uni card number for t.skarbek-wazynski

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_it_raises_error_for_bad_user
		VCR.use_cassette('badge_all_bad_user') do
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(user: "t.skarbek-wazynski") }
		end
	end

	def test_it_raises_error_for_non_existing_user
		VCR.use_cassette('badge_all_badges_bad_user') do
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(user: "t.skarbek-wazynsky@lancaster.ac.uk") }
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(user: "081897144451") }
		end
	end

	def test_it_returns_back_all_badges
		VCR.use_cassette('badge_all') do
			result = Badgeapi::Badge.all

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_it_returns_back_all_badges_exapanded
		VCR.use_cassette('badge_all_expanded') do
			result = Badgeapi::Badge.all(expand: "collection")

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
			assert result.first.collection.kind_of?(Badgeapi::Collection)
		end
	end

	def test_it_errors_all_badges_exapanded
		VCR.use_cassette('badge_all_expanded') do
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(expand: "monkey") }
		end
	end

	def test_it_returns_back_all_badges_from_collection
		VCR.use_cassette('badge_all_from_collection') do
			result = Badgeapi::Badge.all(collection_id: 2)

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_all_limit
		VCR.use_cassette('badge_all_limited') do
			result = Badgeapi::Badge.all(limit: 1)

			assert_equal 1, result.length
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_badges_raise_errors
		VCR.use_cassette('badge_error') do
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.find("safasuf2") }
		end
	end

	def test_create_a_new_badge
		VCR.use_cassette('badge_create') do
			badge = Badgeapi::Badge.create(
				name: "Create Badge Test",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				collection_id: 1,
				level: "silver",
				auto_issue: true
			)

			assert_equal Badgeapi::Badge, badge.class
			assert_equal "Create Badge Test", badge.name
			assert_equal "This is a new badge", badge.description
			assert_equal "You need to love the Badge API", badge.requirements
			assert_equal "Love us..", badge.hint
			assert_equal true, badge.auto_issue

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_create_new_badge_failure
		VCR.use_cassette('badge_create_new') do
			badge = Badgeapi::Badge.create(
				name: "Create Badge Test Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				collection_id: 1,
				level: "bronze"
			)

			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Badge.create(
					name: "Create Badge Test Destroy",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					collection_id: 1,
					level: "bronze"
				)
			}

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_badge_destroy
		VCR.use_cassette('badge_destroy') do
			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				collection_id: 1,
				level: "bronze"
			)

			destroyed_badge = Badgeapi::Badge.destroy(badge.id)

			assert_equal Badgeapi::Badge, destroyed_badge.class

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.destroy(badge.id) }

		end
	end

	def test_badge_destroy_error
		VCR.use_cassette('badge_destroy_error') do
			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				collection_id: 1,
				level: "bronze"
			)

			Badgeapi::Badge.destroy(badge.id)

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.destroy(badge.id) }
		end
	end

	def test_update_badge_via_update
		VCR.use_cassette('badge_update_via_update') do
			badge = Badgeapi::Badge.create(
					name: "Create Badge for update",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					collection_id: 1,
					level: "bronze"
			)

			updated_badge = Badgeapi::Badge.update(badge.id,
					name: "Updated Badge",
					description: "Updated Description",
					requirements: "Updated Requirements",
					hint: "Updated Hint",
					status: "live",
			)

			assert_equal "Updated Badge", updated_badge.name
			assert_equal "Updated Description", updated_badge.description
			assert_equal "Updated Requirements", updated_badge.requirements
			assert_equal "Updated Hint", updated_badge.hint
			assert_equal "live", updated_badge.status

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_update_badge_via_update_with_slug_update_and_history
		VCR.use_cassette('badge_update_via_update_slug_history') do
			badge = Badgeapi::Badge.create(
					name: "Create Badge for update",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					collection_id: 1,
					level: "bronze"
			)

			assert_equal "create-badge-for-update", badge.id


			updated_badge = Badgeapi::Badge.update(badge.id,
												   name: "Updated Badge",
												   description: "Updated Description",
												   requirements: "Updated Requirements",
												   hint: "Updated Hint",
			)

			assert_equal "updated-badge", updated_badge.id
			assert_equal "Updated Badge", updated_badge.name
			assert_equal "Updated Description", updated_badge.description
			assert_equal "Updated Requirements", updated_badge.requirements
			assert_equal "Updated Hint", updated_badge.hint

			using_old_slug = Badgeapi::Badge.find(badge.id)

			assert_equal "Updated Badge", using_old_slug.name

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_should_issue_badge_with_email
		VCR.use_cassette('badge_issue_to_user') do
			recipient = Badgeapi::Badge.issue(
				"mega-book-worm",
				recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert recipient.kind_of?(Badgeapi::Recipient)
			assert recipient.badges.first.kind_of?(Badgeapi::Badge)

			recipient = Badgeapi::Badge.revoke(
					"mega-book-worm",
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)
		end
	end

	def test_should_revoke_badge_with_email
		VCR.use_cassette('badge_revoke_from_user') do
			recipient = Badgeapi::Badge.issue(
					"mega-book-worm",
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			recipient = Badgeapi::Badge.revoke(
					"mega-book-worm",
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert recipient.kind_of?(Badgeapi::Recipient)
		end
	end

	def test_should_issue_badge_with_library_card
		VCR.use_cassette('badge_issue_to_user_with_library_card') do
			recipient = Badgeapi::Badge.issue(
					3,
					recipient: "0043181"
			)

			assert recipient.kind_of?(Badgeapi::Recipient)
			assert recipient.badges.first.kind_of?(Badgeapi::Badge)

			recipient = Badgeapi::Badge.revoke(
					3,
					recipient: "0043181"
			)
		end
	end

	def test_should_error_when_user_param_is_bad
		VCR.use_cassette('badge_issue_to_bad_user') do
			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Badge.issue(
					2,
					recipient: "t.skarbek-wazynski"
				)
			}
		end
	end

	def test_badge_requirements
		VCR.use_cassette('badge_requirements') do
			badge = Badgeapi::Badge.create(
					name: "Create Badge",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					collection_id: 1,
					level: "silver"
			)

			required_badge = Badgeapi::Badge.create(
					name: "Required Badge",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					collection_id: 1,
					level: "bronze"
			)


			required_count = badge.required_badges.count

			badge = Badgeapi::Badge.add_badge_requirement(badge.id, required_badge.id)

			assert_equal required_count + 1, badge.required_badges.count
			assert_equal Badgeapi::Badge, badge.required_badges.first.class

			badge = Badgeapi::Badge.remove_badge_requirement(badge.id, required_badge.id)

			assert_equal required_count, badge.required_badges.count

			Badgeapi::Badge.destroy(badge.id)
			Badgeapi::Badge.destroy(required_badge.id)

		end
	end

end
