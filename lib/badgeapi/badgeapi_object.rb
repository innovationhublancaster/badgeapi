#lib/badgeapi/badgeapi_object.rb

module Badgeapi
	class BadgeapiObject
		class << self

			def initialize attributes = {}
				if instance_of? BadgeapiObject
					raise Error,
						  "#{self.class} is an abstract class and cannot be instantiated"
				end

				self.attributes = attributes
				yield self if block_given?
			end

			def from_response attributes
				record = new
				attributes.each do |name, value|
					record.instance_variable_set "@#{name}", value
				end
				record
			end


			def from_json attributes = {}
				attributes.map { |attributes| new(attributes) }
			end

			attr_reader :attributes

		end
	end
end