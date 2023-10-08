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
        .to_return(status: 200)

      Reconomic::Customer.create(
        properties,
        session: session
      )

      assert_requested(:post, "https://restapi.e-conomic.com/customers")
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
end
