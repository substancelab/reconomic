require_relative "../test_helper"

require "reconomic/session"

describe Reconomic::Session do
  it "can be instantiated" do
    _(Reconomic::Session.new).must_be_instance_of(Reconomic::Session)
  end

  describe "#connect_with_token" do
    it "stores the given tokens" do
      session = Reconomic::Session.new

      session.connect_with_token("app_secret_token", "agreement_grant_token")

      _(session.app_secret_token).must_equal("app_secret_token")
      _(session.agreement_grant_token).must_equal("agreement_grant_token")
    end
  end
end
