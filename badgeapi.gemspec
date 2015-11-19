# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'badgeapi/version'

Gem::Specification.new do |spec|
  spec.name = "badgeapi"
  spec.version 		 = Badgeapi::VERSION
  spec.authors 		 = ["Tom Skarbek Wazynski"]
  spec.email = ["wazynski@gmail.com"]
  spec.summary = "Ruby bindings for the Lancaster University Badge API platform"
  spec.description = "The badgeapi gem provides Ruby bindings for the Lancaster University Badge API
  platform. It allows for quicker and easier access, insertion and consumption of data from the API."
  spec.homepage		 = "https://github.com/innovationhublancaster/badgeapi"
  spec.license 		 = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "minitest-focus", "~> 1.1"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.20"

  # So it works with rails 4 and 3
  spec.add_dependency "activesupport", "> 3.2"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "json", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
