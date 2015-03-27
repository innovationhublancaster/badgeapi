#test/collection/collection_test.rb
require './test/test_helper'

class BadgeapiCollectionTest < MiniTest::Test

	def test_exists
		assert Badgeapi::Collection
	end

	def test_it_returns_back_a_single_collection
		VCR.use_cassette('one_collection') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"

			collection = Badgeapi::Collection.find(1)
			assert_equal Badgeapi::Collection, collection.class

			assert_equal 1, collection.id
			assert_equal "Library", collection.name
			assert_equal "All of the badges available related to library data", collection.description
		end
	end

	def test_it_returns_back_all_collections
		VCR.use_cassette('all_collection') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"

			result = Badgeapi::Collection.all

			# Make sure we got all the badges
			assert_equal 2, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
		end
	end

	def test_all_limit
		VCR.use_cassette('all_collection_limit') do
			Badgeapi.api_key = "c1616687d0fc420d85c8590357d1ab29"

			result = Badgeapi::Collection.all(limit: 1)

			# Make sure we got all the badges
			assert_equal 1, result.length

			# Make sure that the JSON was parsed
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Collection)
		end
	end

	def test_collections_raise_errors
		VCR.use_cassette('collection_error') do
			Badgeapi.api_key= 'c1616687d0fc420d85c8590357d1ab29'
			assert_raises(Exception) { Badgeapi::Collection.find(27) }
		end
	end
end