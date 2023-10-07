require "shale"

require "reconomic/mapper/type/object"

# The draft invoices endpoint is where you go to read and create invoices that
# haven’t been booked yet. While an invoice is still a draft invoice you can
# edit everything. Once you book the invoice you can no longer edit it.
#
# https://restdocs.e-conomic.com/#invoices
class Reconomic::Invoice
  class Mapper < Shale::Mapper
    model Reconomic::Invoice

    # Set up accessors for all the properties we get from the API.
    #
    # https://restdocs.e-conomic.com/#get-customers-customernumber
    attribute :booked_invoice_number, Shale::Type::String
    attribute :currency, Shale::Type::String
    attribute :customer, Reconomic::Mapper::Type::Object
    attribute :date, Shale::Type::Date
    attribute :delivery, Shale::Type::String
    attribute :delivery_location, Shale::Type::String
    attribute :due_date, Shale::Type::String
    attribute :exchange_rate, Shale::Type::String
    attribute :gross_amount, Shale::Type::String
    attribute :gross_amount_in_base_currency, Shale::Type::String
    attribute :layout, Shale::Type::String
    attribute :lines, Shale::Type::String, default: -> { [] }
    attribute :net_amount, Shale::Type::String
    attribute :net_amount_in_base_currency, Shale::Type::String
    attribute :notes, Shale::Type::String
    attribute :payment_terms, Reconomic::Mapper::Type::Object
    attribute :pdf, Shale::Type::String
    attribute :project, Shale::Type::String
    attribute :recipient, Shale::Type::String
    attribute :references, Shale::Type::String
    attribute :remainder, Shale::Type::String
    attribute :remainder_in_base_currency, Shale::Type::String
    attribute :rounding_amount, Shale::Type::String
    attribute :sent, Shale::Type::String
    attribute :vat_amount, Shale::Type::String

    json do
      map "bookedInvoiceNumber", to: :booked_invoice_number
      map "currency", to: :currency
      map "customer", to: :customer, using: {from: :customer_from_json, to: :customer_to_json}
      map "date", to: :date
      map "delivery", to: :delivery
      map "deliveryLocation", to: :delivery_location
      map "dueDate", to: :due_date
      map "exchangeRate", to: :exchange_rate
      map "grossAmount", to: :gross_amount
      map "grossAmountInBaseCurrency", to: :gross_amount_in_base_currency
      map "layout", to: :layout
      map "lines", to: :lines
      map "netAmount", to: :net_amount
      map "netAmountInBaseCurrency", to: :net_amount_in_base_currency
      map "notes", to: :notes
      map "paymentTerms", to: :payment_terms, using: {from: :payment_terms_from_json, to: :payment_terms_to_json}
      map "pdf", to: :pdf
      map "project", to: :project
      map "recipient", to: :recipient
      map "references", to: :references
      map "remainder", to: :remainder
      map "remainderInBaseCurrency", to: :remainder_in_base_currency
      map "roundingAmount", to: :rounding_amount
      map "sent", to: :sent
      map "vatAmount", to: :vat_amount
    end

    def customer_from_json(model, value)
      raise NotImplementedError
    end

    def customer_to_json(model, output)
      output[:customer] = {"customerNumber" => model.customer.customer_number}
    end

    def payment_terms_from_json(model, value)
      raise NotImplementedError
    end

    def payment_terms_to_json(model, output)
      # We expect PaymentTerms to be a hash for now
      output[:paymentTerms] = {
        "paymentTermsNumber" => model.payment_terms.fetch("payment_terms_number")
      }
    end
  end

  attr_accessor \
    :booked_invoice_number,
    :currency,
    :customer,
    :date,
    :delivery,
    :delivery_location,
    :due_date,
    :exchange_rate,
    :gross_amount,
    :gross_amount_in_base_currency,
    :layout,
    :net_amount,
    :net_amount_in_base_currency,
    :notes,
    :payment_terms,
    :pdf,
    :project,
    :recipient,
    :references,
    :remainder,
    :remainder_in_base_currency,
    :rounding_amount,
    :sent,
    :vat_amount
  attr_writer :lines

  class << self
    def retrieve(number:, session:)
    end
  end

  def initialize(values = {})
    initialize_from(values)
  end

  def initialize_from(values)
    values.each do |key, value|
      property_name = ActiveSupport::Inflector.underscore(key.to_s)
      setter_name = "#{property_name.underscore}="
      send(setter_name, value) if respond_to?(setter_name)
    end
  end

  def lines
    @lines ||= []
  end

  # https://restdocs.e-conomic.com/#post-invoices-drafts
  #
  # TODO: For now we're always posting to the drafts endpoint, but we should
  # have support for also booking the invoices:
  # https://restdocs.e-conomic.com/#post-invoices-booked
  def save(session:)
    raise "Expected payment terms to not be a string" if payment_terms.is_a?(String)
    body = construct_json_for_save
    session.post("/invoices/drafts", body)
  end

  private

  def construct_json_for_save
    Mapper.to_json(self, pretty: true)
  end
end
