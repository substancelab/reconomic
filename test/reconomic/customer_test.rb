require_relative "../test_helper"

require "reconomic/customer"

describe Reconomic::Customer do
  it "can be instantiated" do
    _(Reconomic::Customer.new).must_be_instance_of(Reconomic::Customer)
  end

  describe ".construct_from" do
    it "instantiates a new customer from a JSON string" do
      customer = Reconomic::Customer.construct_from(
        "{\"customerNumber\":1,\"name\":\"John Doe\",\"address\":\"Somewhere\"}"
      )
      _(customer.address).must_equal("Somewhere")
      _(customer.customer_number).must_equal(1)
      _(customer.name).must_equal("John Doe")
    end
  end

  describe ".create" do
    it "posts a customer to the API" do
      properties = {
        "currency" => "EUR",
        "customerGroup" => {
          "customerGroupNumber" => 1
        },
        "name" => "Acme Inc",
        "paymentTerms" => {
          "paymentTermsNumber" => 2
        },
        "vatZone" => {
          "vatZoneNumber" => 2
        }
      }

      session = Reconomic::Session.new
      stub_request(:post, "https://restapi.e-conomic.com/customers")
        .with(
          body: properties,
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(body: properties.to_json, status: 200)

      Reconomic::Customer.create(
        properties,
        session: session
      )

      assert_requested(:post, "https://restapi.e-conomic.com/customers")
    end

    it "returns the created customer" do
      properties = {
        "currency" => "EUR",
        "customerGroup" => {
          "customerGroupNumber" => 1
        },
        "name" => "Acme Inc",
        "paymentTerms" => {
          "paymentTermsNumber" => 2
        },
        "vatZone" => {
          "vatZoneNumber" => 2
        }
      }

      session = Reconomic::Session.new
      stub_request(:post, "https://restapi.e-conomic.com/customers")
        .with(
          body: properties,
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(body: properties.to_json, status: 200)

      result = Reconomic::Customer.create(
        properties,
        session: session
      )

      _(result).must_be_instance_of(Reconomic::Customer)
      _(result.name).must_equal("Acme Inc")
    end
  end

  describe ".list" do
    it "returns a list of Customers from the API" do
      response = {
        "collection" => [
          {
            "currency" => "EUR",
            "customerGroup" => {
              "customerGroupNumber" => 1
            },
            "name" => "Acme Inc",
            "paymentTerms" => {
              "paymentTermsNumber" => 2
            },
            "vatZone" => {
              "vatZoneNumber" => 2
            }
          }
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

      session = Reconomic::Session.new
      stub_request(:get, "https://restapi.e-conomic.com/customers")
        .with(
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(body: response.to_json, status: 200)

      results = Reconomic::Customer.list(
        session: session
      )

      assert_requested(:get, "https://restapi.e-conomic.com/customers")
      _(results).must_be_instance_of(Reconomic::Collection)
      _(results.first.name).must_equal("Acme Inc")
    end
  end

  describe ".retrieve" do
    it "retrieves a customer from the API" do
      body = "{\"customerNumber\":1,\"name\":\"John Doe\",\"address\":\"Somewhere\"}"
      stub_request(:get, "https://restapi.e-conomic.com/customers/1")
        .to_return(body: body)

      session = Reconomic::Session.new
      customer = Reconomic::Customer.retrieve(number: 1, session: session)

      _(customer.address).must_equal("Somewhere")
      _(customer.customer_number).must_equal(1)
      _(customer.name).must_equal("John Doe")
    end

    it "raises an error if the request fails" do
      stub_request(:get, "https://restapi.e-conomic.com/customers/1")
        .to_return(status: 401)

      session = Reconomic::Session.new

      _ {
        Reconomic::Customer.retrieve(number: 1, session: session)
      }.must_raise(Reconomic::EconomicError)
    end
  end

  describe ".update" do
    it "puts a customer to the API" do
      properties = {
        "currency" => "EUR",
        "customerGroup" => {
          "customerGroupNumber" => 1
        },
        "name" => "Acme Inc",
        "paymentTerms" => {
          "paymentTermsNumber" => 2
        },
        "vatZone" => {
          "vatZoneNumber" => 2
        }
      }

      session = Reconomic::Session.new
      stub_request(:put, "https://restapi.e-conomic.com/customers/42")
        .with(
          body: properties,
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(body: properties.to_json, status: 200)

      Reconomic::Customer.update(
        42,
        properties,
        session: session
      )

      assert_requested(:put, "https://restapi.e-conomic.com/customers/42")
    end

    it "returns the updated customer" do
      properties = {
        "customerNumber" => 42,
        "name" => "Acme Inc"
      }

      session = Reconomic::Session.new
      stub_request(:put, "https://restapi.e-conomic.com/customers/42")
        .with(
          body: properties,
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(body: properties.to_json, status: 200)

      result = Reconomic::Customer.update(
        42,
        properties,
        session: session
      )

      _(result).must_be_instance_of(Reconomic::Customer)
      _(result.name).must_equal("Acme Inc")
    end
  end
end
