#test/collection/collection_test.rb
require './test/test_helper'

class BadgeapiCollectionTest < MiniTest::Test

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
		VCR.use_cassette('one_collection', :record => :all) do
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"

			collection = Badgeapi::Collection.find(1)
			assert_equal Badgeapi::Collection, collection.class

			assert_equal 1, collection.id
			assert_equal "Library", collection.name
			assert_equal "All of the badges available related to library data", collection.description
		end
	end

	def test_it_returns_back_all_collections
		VCR.use_cassette('all_collection', :record => :all) do
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"

			result = Badgeapi::Collection.all

			# Make sure we got all the badges
			assert_equal 2, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
		end
	end

	def test_all_limit
		VCR.use_cassette('all_collection_limit', :record => :all) do
			Badgeapi.api_key = "86340fbfc17b4032b07592037dcc5e0b"

			result = Badgeapi::Collection.all(limit: 1)

			# Make sure we got all the badges
			assert_equal 1, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
		end
	end

	def test_collections_raise_errors
		VCR.use_cassette('collection_error', :record => :all) do
			Badgeapi.api_key= '86340fbfc17b4032b07592037dcc5e0b'
			assert_raises(Exception) { Badgeapi::Collection.find(27) }
		end
	end

	def test_create_a_new_collection
		VCR.use_cassette('create_collection', :record => :all) do

			Badgeapi.api_key = '86340fbfc17b4032b07592037dcc5e0b'

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
		VCR.use_cassette('create_new_collection_failure', :record => :all) do

			Badgeapi.api_key = '86340fbfc17b4032b07592037dcc5e0b'

			collection = Badgeapi::Collection.create(
				name: "Create Collection Test Destroy",
				description: "This is a new badge"
			)

			assert_raises(Exception) {
				Badgeapi::Collection.create(
					name: "Create Collection Test Destroy",
					description: "This is a new badge"
				)
			}

			Badgeapi::Collection.destroy(collection.id)
		end
	end

	def test_collection_destroy
		VCR.use_cassette('destroy_collection', :record => :all) do

			Badgeapi.api_key = '86340fbfc17b4032b07592037dcc5e0b'

			collection = Badgeapi::Collection.create(
					name: "Create Collection for Destroy",
					description: "This is a new badge",
					requirements: "You need to love the Badge API"
			)

			destroyed_collection = Badgeapi::Collection.destroy(collection.id)

			assert_equal Badgeapi::Collection, destroyed_collection.class

			assert_raises(Exception) { Badgeapi::Collection.find(destroyed_collection.id) }
		end
	end

	def test_collection_destroy_error
		VCR.use_cassette('destroy_collection_error', :record => :all) do

			Badgeapi.api_key = '86340fbfc17b4032b07592037dcc5e0b'

			collection = Badgeapi::Collection.create(
					name: "Create Collection for Destroy",
					description: "This is a new badge"
			)

			destroyed_collection = Badgeapi::Collection.destroy(collection.id)

			assert_raises(Exception) { Badgeapi::Collection.destroy(collection.id) }
		end
	end
end