#test/badge/badge_test.rb
require './test/test_helper'

class BadgeapiBadgeTest < MiniTest::Test

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
		VCR.use_cassette('one_badge', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

			badge = Badgeapi::Badge.find(1)
			assert_equal Badgeapi::Badge, badge.class

			assert_equal "book-worm", badge.id
			assert_equal "Book Worm", badge.name
			assert_equal "You have loaned out over 25 books. Nice going!", badge.description
			assert_equal "Loan out 25 books", badge.requirements
			assert_equal "You must like books...", badge.hint
			#assert_equal "http://openbadges.org/wp-content/themes/openbadges2/media/images/content-background.png", badge.image
			assert_equal "library", badge.collection_id
			assert_equal "bronze", badge.level
			assert_equal 25, badge.points
			assert_equal false, badge.auto_issue
			assert_equal "badge", badge.object
			assert_equal "live", badge.status
		end
	end

	def test_it_returns_back_a_single_badge_expanded
		VCR.use_cassette('one_badge_expanded', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

			badge = Badgeapi::Badge.find(1, expand: "collection")
			assert_equal Badgeapi::Badge, badge.class

			assert_equal "book-worm", badge.id
			assert_equal "Book Worm", badge.name
			assert_equal "You have loaned out over 25 books. Nice going!", badge.description
			assert_equal "Loan out 25 books", badge.requirements
			assert_equal "You must like books...", badge.hint
			#assert_equal "http://openbadges.org/wp-content/themes/openbadges2/media/images/content-background.png", badge.image
			assert_equal "library", badge.collection_id

			assert_equal Badgeapi::Collection, badge.collection.class
			assert_equal "Library", badge.collection.name
		end
	end

	def test_it_returns_back_all_badges_issued_to_user
		VCR.use_cassette('all_badges_issued', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			result = Badgeapi::Badge.all(user: "t.skarbek-wazynski@lancaster.ac.uk")

			# Make sure we got all the badges
			assert_equal 1, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)

			result = Badgeapi::Badge.all(user: "0043181") #uni card number for t.skarbek-wazynski

			# Make sure we got all the badges
			assert_equal 1, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_it_raises_error_for_bad_user
		VCR.use_cassette('all_badges_bad_user', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(user: "t.skarbek-wazynski") }
		end
	end

	def test_it_raises_error_for_non_existing_user
		VCR.use_cassette('all_badges_bad_user', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(user: "t.skarbek-wazynsky@lancaster.ac.uk") }
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(user: "081897144451") }
		end
	end

	def test_it_returns_back_all_badges
		VCR.use_cassette('all_badges', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			result = Badgeapi::Badge.all

			# Make sure we got all the badges
			assert_equal 6, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_it_returns_back_all_badges_exapanded
		VCR.use_cassette('all_badges_expanded', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			result = Badgeapi::Badge.all(expand: "collection")

			# Make sure we got all the badges
			assert_equal 6, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
			assert result.first.collection.kind_of?(Badgeapi::Collection)

			#assert_not_nil result['collection']
		end
	end

	def test_it_errors_all_badges_exapanded
		VCR.use_cassette('all_badges_expanded', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.all(expand: "monkey") }
		end
	end

	def test_it_returns_back_all_badges_from_collection
		VCR.use_cassette('all_badges_from_collection') do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			result = Badgeapi::Badge.all(collection_id: 2)

			# Make sure we got all the badges
			assert_equal 2, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_all_limit
		VCR.use_cassette('all_badges_limited', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"
			result = Badgeapi::Badge.all(limit: 1)

			# Make sure we got all the badges
			assert_equal 1, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_badges_raise_errors
		VCR.use_cassette('badge_error', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.find(27) }
		end
	end

	def test_create_a_new_badge
		VCR.use_cassette('create_badge', :record => :all) do
			Badgeapi.api_key = 'c9cde524238644fa93393159e5e9ad87'

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
			#assert_equal "http://example.org/badge.png", badge.image
			assert_equal "library", badge.collection_id
			assert_equal true, badge.auto_issue
			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_create_new_badge_failure
		VCR.use_cassette('create_new_badge_failure', :record => :all) do
			Badgeapi.api_key = 'c9cde524238644fa93393159e5e9ad87'

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
		VCR.use_cassette('destroy_badge', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

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
		VCR.use_cassette('destroy_badge_error', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				collection_id: 1,
				level: "bronze"
			)

			destroyed_badge = Badgeapi::Badge.destroy(badge.id)

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.destroy(badge.id) }
		end
	end


	def test_update_badge_via_update
		VCR.use_cassette('update_badge_via_update', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

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
					collection_id: "trim-trail"
			)

			assert_equal "Updated Badge", updated_badge.name
			assert_equal "Updated Description", updated_badge.description
			assert_equal "Updated Requirements", updated_badge.requirements
			assert_equal "Updated Hint", updated_badge.hint
			assert_equal "trim-trail", updated_badge.collection_id

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_update_badge_via_update_with_slug_update_and_history
		VCR.use_cassette('update_badge_via_update_slug_history', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

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
												   collection_id: "trim-trail"
			)

			assert_equal "updated-badge", updated_badge.id
			assert_equal "Updated Badge", updated_badge.name
			assert_equal "Updated Description", updated_badge.description
			assert_equal "Updated Requirements", updated_badge.requirements
			assert_equal "Updated Hint", updated_badge.hint
			assert_equal "trim-trail", updated_badge.collection_id

			using_old_slug = Badgeapi::Badge.find(badge.id)

			assert_equal "Updated Badge", using_old_slug.name

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_should_issue_badge_with_email
		VCR.use_cassette('issue_badge_to_user', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			recipient = Badgeapi::Badge.issue(
				"mega-book-worm",
				recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert_equal 2, recipient.badges.length
			assert recipient.kind_of?(Badgeapi::Recipient)
			assert recipient.badges.first.kind_of?(Badgeapi::Badge)

			recipient = Badgeapi::Badge.revoke(
					"mega-book-worm",
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert_equal 1, recipient.badges.length
		end
	end

	def test_should_revoke_badge_with_email
		VCR.use_cassette('revoke_badge_from_user', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			recipient = Badgeapi::Badge.issue(
					"mega-book-worm",
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert_equal 2, recipient.badges.length

			recipient = Badgeapi::Badge.revoke(
					"mega-book-worm",
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert_equal 1, recipient.badges.length
			assert recipient.kind_of?(Badgeapi::Recipient)
			assert recipient.badges.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_should_issue_badge_with_library_card
		VCR.use_cassette('issue_badge_to_user_with_library_card', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			recipient = Badgeapi::Badge.issue(
					3,
					recipient: "0043181"
			)


			assert_equal 2, recipient.badges.length
			assert recipient.kind_of?(Badgeapi::Recipient)
			assert recipient.badges.first.kind_of?(Badgeapi::Badge)

			recipient = Badgeapi::Badge.revoke(
					3,
					recipient: "0043181"
			)

			assert_equal 1, recipient.badges.length
		end
	end

	def test_should_error_when_user_param_is_bad
		VCR.use_cassette('issue_badge_to_bad_user', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Badge.issue(
					2,
					recipient: "t.skarbek-wazynski"
				)
			}
		end
	end

	def test_should_error_when_issuing_bad_already_issued
		VCR.use_cassette('issue_already_owned_badge', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Badge.issue(
						1,
						recipient: "t.skarbek-wazynski@lancaster.ac.uk"
				)
			}
		end
	end

	def test_should_error_when_revoking_badge_not_owned
		VCR.use_cassette('revoke_badge_not_issued', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Badge.revoke(
						3,
						recipient: "t.skarbek-wazynski@lancaster.ac.uk"
				)
			}
		end
	end

	def test_badge_requirements
		VCR.use_cassette('badge_requirements', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.find("marathon-man")

			required_count = badge.required_badges.count

			badge = Badgeapi::Badge.add_badge_requirement("marathon-man", "you-trim-trailed")

			assert_equal required_count + 1, badge.required_badges.count
			assert_equal Badgeapi::Badge, badge.required_badges.first.class

			badge = Badgeapi::Badge.remove_badge_requirement("marathon-man", "you-trim-trailed")

			assert_equal required_count, badge.required_badges.count
		end
	end

end