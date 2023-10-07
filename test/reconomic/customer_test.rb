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
  end
end
