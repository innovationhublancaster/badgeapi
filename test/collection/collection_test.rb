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
		assert Badgeapi::Collection
	end

	def test_object_path
		assert_equal "collections", Badgeapi::Collection.collection_path
	end

	def test_object_name
		assert_equal "collection", Badgeapi::Collection.member_name
	end

	def test_it_returns_back_a_single_collection
		VCR.use_cassette('collection_one') do
			collection = Badgeapi::Collection.find(1)
			assert_equal Badgeapi::Collection, collection.class

			assert_kind_of String, collection.id
			assert_kind_of String, collection.name
			assert_kind_of Integer, collection.total_points_available
			assert_kind_of Integer, collection.badge_count
			assert_kind_of String, collection.description
		end
	end

	def test_it_returns_back_a_single_collection_expanded
		VCR.use_cassette('collection_one_expanded') do
			collection = Badgeapi::Collection.find(1, expand: "badges")

			assert_equal Badgeapi::Collection, collection.class

			assert_kind_of String, collection.id
			assert_kind_of String, collection.name
			assert_kind_of Integer, collection.total_points_available
			assert_kind_of String, collection.description

			assert_kind_of Array, collection.badges
			assert_kind_of Integer, collection.badges.length

			if collection.badges.length > 0
				assert_kind_of String, collection.badges.first.name
				assert_kind_of String, collection.badges.first.level
				assert_kind_of Integer, collection.badges.first.points
			end
		end
	end

	def test_it_returns_back_all_collections
		VCR.use_cassette('collection_all') do
			result = Badgeapi::Collection.all

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
		end
	end

	def test_it_returns_back_all_collections_expanded
		VCR.use_cassette('collection_all_expanded') do
			result = Badgeapi::Collection.all(expand: "badges")

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
			assert result.first.badges.first.kind_of?(Badgeapi::Badge)

			if result.first.badges.length > 0
				assert_kind_of String, result.first.badges.first.name
				assert_kind_of String, result.first.badges.first.level
				assert_kind_of Integer, result.first.badges.first.points
				result.first.badges.each do |badge|
					assert_equal Badgeapi::Badge, badge.class
				end
			end
		end
	end

	def test_all_limit
		VCR.use_cassette('collection_all_limit') do
			result = Badgeapi::Collection.all(limit: 1)

			assert_equal 1, result.length

			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
		end
	end

	def test_collections_raise_errors
		VCR.use_cassette('collection_error') do
			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Collection.find("2df3") }

			begin
				Badgeapi::Collection.find("dgsgdsg")
			rescue Badgeapi::InvalidRequestError => e
				assert_equal(404, e.http_status)
				refute_empty e.message
				assert_equal(true, e.json_body.kind_of?(Hash))
			end
		end
	end

	def test_create_a_new_collection
		VCR.use_cassette('collection_create') do
			collection = Badgeapi::Collection.create(
				name: "Create Collection Test",
				description: "This is a new collection"
			)

			assert_equal Badgeapi::Collection, collection.class
			assert_equal "Create Collection Test", collection.name
			assert_equal "This is a new collection", collection.description

			Badgeapi::Collection.destroy(collection.id)
		end
	end

	def test_create_new_collection_failure
		VCR.use_cassette('collection_create_new_failure') do
			collection = Badgeapi::Collection.create(
				name: "Create Collection Test Destroy",
				description: "This is a new badge"
			)

			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Collection.create(
						name: "Create Collection Test Destroy",
						description: "This is a new badge"
				)
			}

			begin
				Badgeapi::Collection.create(
						name: "Create Collection Test Destroy",
						description: "This is a new badge"
				)
			rescue Badgeapi::InvalidRequestError => e
				assert_equal(422, e.http_status)
				refute_empty e.message
				assert_equal(true, e.json_body.kind_of?(Hash))
			end

			Badgeapi::Collection.destroy(collection.id)
		end
	end

	def test_collection_destroy
		VCR.use_cassette('collection_destroy') do
			collection = Badgeapi::Collection.create(
					name: "Create Collection for Destroy",
					description: "This is a new badge",
			)

			destroyed_collection = Badgeapi::Collection.destroy(collection.id)

			assert_equal Badgeapi::Collection, destroyed_collection.class

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Collection.find(destroyed_collection.id) }

			begin
				Badgeapi::Collection.find(destroyed_collection.id)
			rescue Badgeapi::InvalidRequestError => e
				assert_equal(404, e.http_status)
				refute_empty e.message
				assert_equal(true, e.json_body.kind_of?(Hash))
			end
		end
	end

	def test_collection_destroy_error
		VCR.use_cassette('collection_destroy_error') do
			collection = Badgeapi::Collection.create(
					name: "Create Collection for Destroy",
					description: "This is a new badge"
			)

			Badgeapi::Collection.destroy(collection.id)

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Collection.destroy(collection.id) }

			begin
				Badgeapi::Collection.destroy(collection.id)
			rescue Badgeapi::InvalidRequestError => e
				assert_equal(404, e.http_status)
				refute_empty e.message
				assert_equal(true, e.json_body.kind_of?(Hash))
			end
		end
	end

	def test_update_collection
		VCR.use_cassette('collection_update') do
			collection = Badgeapi::Collection.create(
					name: "Create Collection for update",
					description: "This is a new collection",
			)

			collection.name = "Updated Collection"
			collection.description = "Updated Collection"

			collection.save

			updated_collection = Badgeapi::Collection.find(collection.id)

			assert_equal "Updated Collection", updated_collection.name
			assert_equal "Updated Collection", updated_collection.description

			Badgeapi::Collection.destroy(collection.id)
		end
	end

	def test_update_collection_via_update
		VCR.use_cassette('collection_update_via_update') do
			collection = Badgeapi::Collection.create(
				name: "Create Collection for update",
				description: "This is a new collection",
			)

			updated_collection = Badgeapi::Collection.update(collection.id,
				name: "Updated Badge",
				description: "Updated Description",
			)

			assert_equal "Updated Badge", updated_collection.name
			assert_equal "Updated Description", updated_collection.description

			Badgeapi::Collection.destroy(collection.id)
		end
	end
end
