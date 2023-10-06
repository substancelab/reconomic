require "shale/type/value"

module Reconomic
  module Mapper
    module Type
      class Object < Shale::Type::Value
        def self.cast(value)
          return nil if value.nil?

          # A Hash is a fine way to represent a generic object
          return handle_hash(value) if value.is_a?(Hash)

          raise ArgumentError, "Don't know how to cast #{value.inspect} in #{self}"
        end

        def self.handle_hash(hash)
          hash.to_h { |k, v| [ActiveSupport::Inflector.underscore(k.to_s), v] }
        end
      end
    end
  end
end
