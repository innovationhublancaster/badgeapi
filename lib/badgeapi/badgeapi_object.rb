#lib/badgeapi/badgeapi_object.rb

module Badgeapi
	class BadgeapiObject
		class << self

			def define_attribute_methods attribute_names
				attribute_names.each do |name|
					define_method name.to_s do
						return instance_variable_get("@#{name}".to_sym)
					end

					define_method "#{name}=" do |val|
						instance_variable_set("@#{name}".to_sym, val)
					end
				end
			end

			attr_reader :attribute_names

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
					#"@#{name}" = value.to_s
				end

				# record.persist! if record.respond_to? :persist!
				record
			end


			def from_json attributes = {}
				attributes.map { |attributes| new(attributes) }
			end

			attr_reader :attributes

		end
	end
end