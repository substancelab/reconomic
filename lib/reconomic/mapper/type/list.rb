require "active_support/inflector"
require "shale/type/value"

module Reconomic
  module Mapper
    module Type
      class List < Shale::Type::Value
        def self.cast(value)
          return nil if value.nil?

          return handle_array(value) if value.is_a?(Array)

          raise ArgumentError, "Don't know how to cast #{value.inspect} in #{self}"
        end

        def self.handle_array(array)
          array
        end
      end
    end
  end
end
