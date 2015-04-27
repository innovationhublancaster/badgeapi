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

			assert_equal 1, badge.id
			assert_equal "Book Worm", badge.name
			assert_equal "Description?", badge.description
			assert_equal "Loan out 25 books", badge.requirements
			assert_equal "You must like books...", badge.hint
			#assert_equal "http://openbadges.org/wp-content/themes/openbadges2/media/images/content-background.png", badge.image
			assert_equal 1, badge.collection_id
		end
	end

	def test_it_returns_back_a_single_badge_expanded
		VCR.use_cassette('one_badge_expanded', :record => :all) do
			Badgeapi.api_key = "c9cde524238644fa93393159e5e9ad87"

			badge = Badgeapi::Badge.find(1, expand: "collection")
			assert_equal Badgeapi::Badge, badge.class

			assert_equal 1, badge.id
			assert_equal "Book Worm", badge.name
			assert_equal "Description?", badge.description
			assert_equal "Loan out 25 books", badge.requirements
			assert_equal "You must like books...", badge.hint
			#assert_equal "http://openbadges.org/wp-content/themes/openbadges2/media/images/content-background.png", badge.image
			assert_equal 1, badge.collection_id

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

			result = Badgeapi::Badge.all(user: "0043181")

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
			@base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAMAAABFaP0WAAAAGXRFWHRTb2Z0\nd2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9i\nZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2Vo\naUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6\nbnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5\nLjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpS\nREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk\nZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIg\neG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxu\nczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1s\nbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9S\nZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9w\nIENDIDIwMTQgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5p\naWQ6QzhEQTNDRjlEQjgwMTFFNEE3Q0E5REQ3NUEzNkE5NTEiIHhtcE1NOkRv\nY3VtZW50SUQ9InhtcC5kaWQ6QzhEQTNDRkFEQjgwMTFFNEE3Q0E5REQ3NUEz\nNkE5NTEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0i\neG1wLmlpZDpDOERBM0NGN0RCODAxMUU0QTdDQTlERDc1QTM2QTk1MSIgc3RS\nZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpDOERBM0NGOERCODAxMUU0QTdDQTlE\nRDc1QTM2QTk1MSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8\nL3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PlCcFjQAAAAGUExURZTB\nIgAAAP3eS0QAAAAOSURBVHjaYmAAAYAAAwAABgAB4EIRTgAAAABJRU5ErkJg\ngg==\n"

			Badgeapi.api_key = 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.create(
				name: "Create Badge Test",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: @base64_image,
				collection_id: 1
			)

			assert_equal Badgeapi::Badge, badge.class
			assert_equal "Create Badge Test", badge.name
			assert_equal "This is a new badge", badge.description
			assert_equal "You need to love the Badge API", badge.requirements
			assert_equal "Love us..", badge.hint
			#assert_equal "http://example.org/badge.png", badge.image
			assert_equal 1, badge.collection_id

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_create_new_badge_failure
		VCR.use_cassette('create_new_badge_failure', :record => :all) do
			@base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAMAAABFaP0WAAAAGXRFWHRTb2Z0\nd2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9i\nZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2Vo\naUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6\nbnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5\nLjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpS\nREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk\nZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIg\neG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxu\nczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1s\nbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9S\nZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9w\nIENDIDIwMTQgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5p\naWQ6QzhEQTNDRjlEQjgwMTFFNEE3Q0E5REQ3NUEzNkE5NTEiIHhtcE1NOkRv\nY3VtZW50SUQ9InhtcC5kaWQ6QzhEQTNDRkFEQjgwMTFFNEE3Q0E5REQ3NUEz\nNkE5NTEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0i\neG1wLmlpZDpDOERBM0NGN0RCODAxMUU0QTdDQTlERDc1QTM2QTk1MSIgc3RS\nZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpDOERBM0NGOERCODAxMUU0QTdDQTlE\nRDc1QTM2QTk1MSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8\nL3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PlCcFjQAAAAGUExURZTB\nIgAAAP3eS0QAAAAOSURBVHjaYmAAAYAAAwAABgAB4EIRTgAAAABJRU5ErkJg\ngg==\n"

			Badgeapi.api_key = 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.create(
				name: "Create Badge Test Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: @base64_image,
				collection_id: 1
			)

			assert_raises(Badgeapi::InvalidRequestError) {
				Badgeapi::Badge.create(
					name: "Create Badge Test Destroy",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					image: @base64_image,
					collection_id: 1
				)
			}

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_badge_destroy
		VCR.use_cassette('destroy_badge', :record => :all) do
			@base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAMAAABFaP0WAAAAGXRFWHRTb2Z0\nd2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9i\nZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2Vo\naUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6\nbnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5\nLjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpS\nREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk\nZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIg\neG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxu\nczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1s\nbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9S\nZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9w\nIENDIDIwMTQgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5p\naWQ6QzhEQTNDRjlEQjgwMTFFNEE3Q0E5REQ3NUEzNkE5NTEiIHhtcE1NOkRv\nY3VtZW50SUQ9InhtcC5kaWQ6QzhEQTNDRkFEQjgwMTFFNEE3Q0E5REQ3NUEz\nNkE5NTEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0i\neG1wLmlpZDpDOERBM0NGN0RCODAxMUU0QTdDQTlERDc1QTM2QTk1MSIgc3RS\nZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpDOERBM0NGOERCODAxMUU0QTdDQTlE\nRDc1QTM2QTk1MSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8\nL3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PlCcFjQAAAAGUExURZTB\nIgAAAP3eS0QAAAAOSURBVHjaYmAAAYAAAwAABgAB4EIRTgAAAABJRU5ErkJg\ngg==\n"

			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: @base64_image,
				collection_id: 1
			)

			destroyed_badge = Badgeapi::Badge.destroy(badge.id)

			assert_equal Badgeapi::Badge, destroyed_badge.class

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.find(destroyed_badge.id) }
		end
	end

	def test_badge_destroy_error
		VCR.use_cassette('destroy_badge_error', :record => :all) do
			@base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAMAAABFaP0WAAAAGXRFWHRTb2Z0\nd2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9i\nZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2Vo\naUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6\nbnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5\nLjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpS\nREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk\nZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIg\neG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxu\nczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1s\nbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9S\nZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9w\nIENDIDIwMTQgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5p\naWQ6QzhEQTNDRjlEQjgwMTFFNEE3Q0E5REQ3NUEzNkE5NTEiIHhtcE1NOkRv\nY3VtZW50SUQ9InhtcC5kaWQ6QzhEQTNDRkFEQjgwMTFFNEE3Q0E5REQ3NUEz\nNkE5NTEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0i\neG1wLmlpZDpDOERBM0NGN0RCODAxMUU0QTdDQTlERDc1QTM2QTk1MSIgc3RS\nZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpDOERBM0NGOERCODAxMUU0QTdDQTlE\nRDc1QTM2QTk1MSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8\nL3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PlCcFjQAAAAGUExURZTB\nIgAAAP3eS0QAAAAOSURBVHjaYmAAAYAAAwAABgAB4EIRTgAAAABJRU5ErkJg\ngg==\n"

			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.create(
				name: "Create Badge for Destroy",
				description: "This is a new badge",
				requirements: "You need to love the Badge API",
				hint: "Love us..",
				image: @base64_image,
				collection_id: 1
			)

			destroyed_badge = Badgeapi::Badge.destroy(badge.id)

			assert_raises(Badgeapi::InvalidRequestError) { Badgeapi::Badge.destroy(badge.id) }
		end
	end


	def test_update_badge_via_update
		VCR.use_cassette('update_badge_via_update', :record => :all) do
			@base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAMAAABFaP0WAAAAGXRFWHRTb2Z0\nd2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9i\nZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2Vo\naUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6\nbnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5\nLjE1NTc3MiwgMjAxNC8wMS8xMy0xOTo0NDowMCAgICAgICAgIj4gPHJkZjpS\nREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk\nZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIg\neG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxu\nczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1s\nbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9S\nZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9w\nIENDIDIwMTQgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5p\naWQ6QzhEQTNDRjlEQjgwMTFFNEE3Q0E5REQ3NUEzNkE5NTEiIHhtcE1NOkRv\nY3VtZW50SUQ9InhtcC5kaWQ6QzhEQTNDRkFEQjgwMTFFNEE3Q0E5REQ3NUEz\nNkE5NTEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0i\neG1wLmlpZDpDOERBM0NGN0RCODAxMUU0QTdDQTlERDc1QTM2QTk1MSIgc3RS\nZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpDOERBM0NGOERCODAxMUU0QTdDQTlE\nRDc1QTM2QTk1MSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8\nL3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PlCcFjQAAAAGUExURZTB\nIgAAAP3eS0QAAAAOSURBVHjaYmAAAYAAAwAABgAB4EIRTgAAAABJRU5ErkJg\ngg==\n"

			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			badge = Badgeapi::Badge.create(
					name: "Create Badge for update",
					description: "This is a new badge",
					requirements: "You need to love the Badge API",
					hint: "Love us..",
					image: @base64_image,
					collection_id: 1
			)

			updated_badge = Badgeapi::Badge.update(badge.id,
					name: "Updated Badge",
					description: "Updated Description",
					requirements: "Updated Requirements",
					hint: "Updated Hint",
					collection_id: 2
			)

			assert_equal "Updated Badge", updated_badge.name
			assert_equal "Updated Description", updated_badge.description
			assert_equal "Updated Requirements", updated_badge.requirements
			assert_equal "Updated Hint", updated_badge.hint
			assert_equal 2, updated_badge.collection_id

			Badgeapi::Badge.destroy(badge.id)
		end
	end

	def test_should_issue_badge_with_email
		VCR.use_cassette('issue_badge_to_user', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			result = Badgeapi::Badge.issue(
				2,
				recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert_equal 2, result.length
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)

			Badgeapi::Badge.revoke(
					2,
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)
		end
	end

	def test_should_revoke_badge_with_email
		VCR.use_cassette('revoke_badge_from_user', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			result = Badgeapi::Badge.issue(
					2,
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			result = Badgeapi::Badge.revoke(
					2,
					recipient: "t.skarbek-wazynski@lancaster.ac.uk"
			)

			assert_equal 1, result.length
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
		end
	end

	def test_should_issue_badge_with_library_card
		VCR.use_cassette('issue_badge_to_user_with_library_card', :record => :all) do
			Badgeapi.api_key= 'c9cde524238644fa93393159e5e9ad87'

			result = Badgeapi::Badge.issue(
					3,
					recipient: "0043181"
			)


			assert_equal 2, result.length
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)

			result = Badgeapi::Badge.revoke(
					3,
					recipient: "0043181"
			)

			assert_equal 1, result.length
			assert result.kind_of?(Array)
			assert result.first.kind_of?(Badgeapi::Badge)
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

end