#test/test_helper.rb
require './lib/badgeapi'
require 'minitest/autorun'
require 'webmock/minitest'
require 'minitest/focus'
require 'vcr'

VCR.configure do |c|
	c.cassette_library_dir = "test/fixtures"
	c.hook_into :webmock
end
