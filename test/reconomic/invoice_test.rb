require_relative "../test_helper"

require "reconomic/invoice"

describe Reconomic::Invoice do
  it "can be instantiated" do
    _(Reconomic::Invoice.new).must_be_instance_of(Reconomic::Invoice)
  end

  describe "#lines" do
    it "defaults to an empty array" do
      invoice = Reconomic::Invoice.new

      _(invoice.lines).must_equal([])
    end
  end

  describe "#save" do
    it "posts a draft invoice to the API" do
      customer = Reconomic::Customer.new
      session = Reconomic::Session.new

      invoice = Reconomic::Invoice.new
      invoice.customer = customer
      invoice.payment_terms = {"payment_terms_number" => 1}

      expected_body = {
        "customer" => {
          "customerNumber" => nil
        },
        "lines" => [],
        "paymentTerms" => {
          "paymentTermsNumber" => 1
        }
      }
      stub_request(:post, "https://restapi.e-conomic.com/invoices/drafts")
        .with(
          body: expected_body,
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(status: 200)

      invoice.save(session: session)
    end
  end
end
