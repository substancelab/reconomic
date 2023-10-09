require "reconomic/mapper/type/list"
require "reconomic/mapper/type/object"

# https://restdocs.e-conomic.com/#collections-vs-resources
class Reconomic::Collection
  class Mapper < Shale::Mapper
    model Reconomic::Collection

    # Sample collection response:
    #
    # {
    #   "collection": [
    #     {
    #       "customerNumber": 1,
    #       ...
    #     },
    #     {
    #       "customerNumber": 2,
    #       ...
    #     }
    #   ],
    #   "pagination": {
    #     "maxPageSizeAllowed": 1000,
    #     "skipPages": 0,
    #     "pageSize": 20,
    #     "results": 32,
    #     "resultsWithoutFilter": 32,
    #     "firstPage": "https://restapi.e-conomic.com/customers?skippages=0&pagesize=20",
    #     "nextPage": "https://restapi.e-conomic.com/customers?skippages=1&pagesize=20",
    #     "lastPage": "https://restapi.e-conomic.com/customers?skippages=1&pagesize=20"
    #   },
    #   "metaData": {
    #     "create": {
    #       "description": "Create a new customer",
    #       "href": "https://restapi.e-conomic.com/customers",
    #       "httpMethod": "post"
    #     }
    #   },
    #   "self": "https://restapi.e-conomic.com/customers"
    # }

    # Set up accessors for all the properties we get from the API.
    #
    # https://restdocs.e-conomic.com/#get-customers-customernumber
    attribute :collection, Reconomic::Mapper::Type::List
    attribute :pagination, Reconomic::Mapper::Type::Object
    attribute :meta_data, Reconomic::Mapper::Type::Object
  end

  include Enumerable

  extend Forwardable
  def_delegator :collection, :each

  attr_accessor :collection, :meta_data, :pagination

  def self.construct_from(json, model:)
    Mapper.from_json(json || "").tap do |this|
      this.collection = this.map do |item|
        model.construct_from(item)
      end
    end
  end

  def has_more?
    !pagination["next_page"].nil?
  end

  def size
    pagination["results"]
  end

  def to_a
    collection
  end
end
