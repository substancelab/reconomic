# frozen_string_literal: true

require_relative "reconomic/version"

require_relative "reconomic/customer"
require_relative "reconomic/invoice"
require_relative "reconomic/product"
require_relative "reconomic/session"

module Reconomic
  class Error < StandardError; end

  # Used when the e-conomic API returns an error
  class EconomicError < Error; end
end
