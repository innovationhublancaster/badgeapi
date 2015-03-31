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
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"

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
		VCR.use_cassette('all_badges', :record => :all) do
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"
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
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"
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
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"
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
			Badgeapi.api_key= '86340fbfc17b4032b07592037dcc5e0b'
			assert_raises(Exception) { Badgeapi::Badge.find(27) }
		end
	end

	def test_create_a_new_badge
		VCR.use_cassette('create_badge', :record => :all) do

			Badgeapi.api_key = '86340fbfc17b4032b07592037dcc5e0b'

			badge = Badgeapi::Badge.create(
				name: "Create Badge Test",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: "http://example.org/badge.png",
				collection_id: 1
			)

			assert_equal Badgeapi::Badge, badge.class
			assert_equal "Create Badge Test", badge.name
			assert_equal "This is a new badge", badge.description
			assert_equal "You need to love the Badge API", badge.requirements
			assert_equal "Love us..", badge.hint
			assert_equal "http://example.org/badge.png", badge.image
			assert_equal 1, badge.collection_id

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_create_new_badge_failure
		VCR.use_cassette('create_new_badge_failure', :record => :all) do

			Badgeapi.api_key = '86340fbfc17b4032b07592037dcc5e0b'

			badge = Badgeapi::Badge.create(
				name: "Create Badge Test Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: "http://example.org/badge.png",
				collection_id: 1
			)

			assert_raises(Exception) {
				Badgeapi::Badge.create(
					name: "Create Badge Test Destroy",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					image: "http://example.org/badge.png",
					collection_id: 1
				)
			}

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_badge_destroy
		VCR.use_cassette('destroy_badge', :record => :all) do

			Badgeapi.api_key= '86340fbfc17b4032b07592037dcc5e0b'

			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: "http://example.org/badge.png",
				collection_id: 1
			)

			destroyed_badge = Badgeapi::Badge.destroy(badge.id)

			assert_equal Badgeapi::Badge, destroyed_badge.class

			assert_raises(Exception) { Badgeapi::Badge.find(destroyed_badge.id) }
		end
	end

	def test_badge_destroy_error
		VCR.use_cassette('destroy_badge_error', :record => :all) do

			Badgeapi.api_key= '86340fbfc17b4032b07592037dcc5e0b'

			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: "http://example.org/badge.png",
				collection_id: 1
			)

			destroyed_badge = Badgeapi::Badge.destroy(badge.id)

			assert_raises(Exception) { Badgeapi::Badge.destroy(badge.id) }
		end
	end

	# def test_update_badge
	# 	VCR.use_cassette('destroy_badge_error', :record => :all) do
	#
	# 		Badgeapi.api_key= '86340fbfc17b4032b07592037dcc5e0b'
	#
	# 		badge = Badgeapi::Badge.create(
	# 				name: "Create Badge for update",
	# 				description: "This is a new badge",
	# 				requirements: "You need to love the Badge API",
	# 				hint: "Love us..",
	# 				image: "http://example.org/badge.png",
	# 				collection_id: 1
	# 		)
	#
	# 		badge = Badgeapi::Badge.update(badge.id,
	# 				name: "Updated Badge",
	# 		)
	#
	# 	end
	# end



end