# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'badgeapi/version'

Gem::Specification.new do |spec|
	spec.name 				= "badgeapi"
	spec.version 			= Badgeapi::VERSION
	spec.authors 			= ["Tom Skarbek Wazynski"]
	spec.email 				= ["wazynski@gmail.com"]
	spec.summary 			= %q{Allows you to connect to Lancaster University Badge API to manipulate badges, issue badges and display badges.}
	spec.description 			= %q{Allows you to connect to Lancaster University Badge API to manipulate badges, issue badges and display badges.}
	spec.homepage			= "http://innovationhub.lancaster.ac.uk"
	spec.license 			= "MIT"

	spec.files 				= `git ls-files -z`.split("\x0")
	spec.executables 		= spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files 		= spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths 		= ["lib"]

	spec.add_development_dependency "minitest"
	spec.add_development_dependency "vcr"
	spec.add_development_dependency "webmock"

	spec.add_dependency "activesupport"
	spec.add_dependency "faraday"
	spec.add_dependency "json"

	spec.add_development_dependency "bundler", "~> 1.7"
	spec.add_development_dependency "rake", "~> 10.0"
end
