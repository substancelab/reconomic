require_relative "../test_helper"

require "reconomic/collection"

describe Reconomic::Collection do
  before do
    @parsed_response = {
      "collection" => [
        {"customerNumber" => 1},
        {"customerNumber" => 2}
      ],
      "pagination" => {
        "maxPageSizeAllowed" => 1000,
        "skipPages" => 0,
        "pageSize" => 20,
        "results" => 32,
        "resultsWithoutFilter" => 32,
        "firstPage" => "https://restapi.e-conomic.com/customers?skippages=0&pagesize=20",
        "nextPage" => "https://restapi.e-conomic.com/customers?skippages=1&pagesize=20",
        "lastPage" => "https://restapi.e-conomic.com/customers?skippages=1&pagesize=20"
      },
      "metaData" => {
        "create" => {
          "description" => "Create a new customer",
          "href" => "https://restapi.e-conomic.com/customers",
          "httpMethod" => "post"
        }
      },
      "self" => "https://restapi.e-conomic.com/customers"
    }
  end

  it "can be instantiated" do
    _(Reconomic::Collection.new).must_be_instance_of(Reconomic::Collection)
  end

  it "can be iterated over" do
    collection = Reconomic::Collection.construct_from(
      @parsed_response.to_json,
      model: Reconomic::Customer
    )
    count = 0
    collection.map { count += 1 }
    _(count).must_equal(2)
  end

  it "contains a collection of model objects" do
    collection = Reconomic::Collection.construct_from(
      @parsed_response.to_json,
      model: Reconomic::Customer
    )

    _(collection.first).must_be_instance_of(Reconomic::Customer)
    _(collection.first.customer_number).must_equal(1)
  end

  describe ".construct_from" do
    it "instantiates a new collection from a JSON string" do
      collection = Reconomic::Collection.construct_from(
        @parsed_response.to_json,
        model: Reconomic::Customer
      )
      _(collection.to_a.size).must_equal(2)
      _(collection.size).must_equal(32)
      _(collection.has_more?).must_equal(true)
    end
  end
end
