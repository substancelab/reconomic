require "http"
require "shale"

require "reconomic/mapper/type/object"

# For more information please look at the Danish e-copedia article
# http://wiki2.e-conomic.dk/salg/kunder-kunder-ny-kunde.
class Reconomic::Customer
  class Mapper < Shale::Mapper
    model Reconomic::Customer

    # Set up mappings for all the properties we get from the API.
    #
    # https://restdocs.e-conomic.com/#get-customers-customernumber
    attribute :address, Shale::Type::String
    attribute :attention, Shale::Type::String
    attribute :balance, Shale::Type::String
    attribute :barred, Shale::Type::String
    attribute :city, Shale::Type::String
    attribute :contacts, Shale::Type::String
    attribute :corporate_identification_number, Shale::Type::String
    attribute :country, Shale::Type::String
    attribute :credit_limit, Shale::Type::String
    attribute :currency, Shale::Type::String
    attribute :customer_contact, Shale::Type::String
    attribute :customer_group, Shale::Type::String
    attribute :customer_number, Shale::Type::Integer
    attribute :default_delivery_location, Shale::Type::String
    attribute :delivery_locations, Shale::Type::String
    attribute :due_amount, Shale::Type::String
    attribute :ean, Shale::Type::String
    attribute :e_invoicing_disabled_by_default, Shale::Type::String
    attribute :email, Shale::Type::String
    attribute :invoices, Shale::Type::String
    attribute :last_updated, Shale::Type::String
    attribute :layout, Shale::Type::String
    attribute :meta_data, Shale::Type::String
    attribute :mobile_phone, Shale::Type::String
    attribute :name, Shale::Type::String
    attribute :payment_terms, Reconomic::Mapper::Type::Object
    attribute :p_number, Shale::Type::String
    attribute :public_entry_number, Shale::Type::String
    attribute :sales_person, Shale::Type::String
    attribute :telephone_and_fax_number, Shale::Type::String
    attribute :templates, Shale::Type::String
    attribute :totals, Shale::Type::String
    attribute :vat_number, Shale::Type::String
    attribute :vat_zone, Reconomic::Mapper::Type::Object
    attribute :website, Shale::Type::String
    attribute :zip, Shale::Type::String

    json do
      map "address", to: :address
      map "attention", to: :attention
      map "balance", to: :balance
      map "barred", to: :barred
      map "city", to: :city
      map "contacts", to: :contacts
      map "corporateIdentificationNumber", to: :corporate_identification_number
      map "country", to: :country
      map "creditLimit", to: :credit_limit
      map "currency", to: :currency
      map "customerContact", to: :customer_contact
      map "customerGroup", to: :customer_group
      map "customerNumber", to: :customer_number
      map "defaultDeliveryLocation", to: :default_delivery_location
      map "deliveryLocations", to: :delivery_locations
      map "dueAmount", to: :due_amount
      map "ean", to: :ean
      map "eInvoicingDisabledByDefault", to: :e_invoicing_disabled_by_default
      map "email", to: :email
      map "invoices", to: :invoices
      map "lastUpdated", to: :last_updated
      map "layout", to: :layout
      map "metaData", to: :meta_data
      map "mobilePhone", to: :mobile_phone
      map "name", to: :name
      map "paymentTerms", to: :payment_terms
      map "pNumber", to: :p_number
      map "publicEntryNumber", to: :public_entry_number
      map "salesPerson", to: :sales_person
      map "telephoneAndFaxNumber", to: :telephone_and_fax_number
      map "templates", to: :templates
      map "totals", to: :totals
      map "vatNumber", to: :vat_number
      map "vatZone", to: :vat_zone
      map "website", to: :website
      map "zip", to: :zip
    end
  end

  attr_accessor \
    :address,
    :attention,
    :balance,
    :barred,
    :city,
    :contacts,
    :corporate_identification_number,
    :country,
    :credit_limit,
    :currency,
    :customer_contact,
    :customer_group,
    :customer_number,
    :default_delivery_location,
    :delivery_locations,
    :due_amount,
    :ean,
    :e_invoicing_disabled_by_default,
    :email,
    :invoices,
    :last_updated,
    :layout,
    :meta_data,
    :mobile_phone,
    :name,
    :payment_terms,
    :p_number,
    :public_entry_number,
    :sales_person,
    :telephone_and_fax_number,
    :templates,
    :totals,
    :vat_number,
    :vat_zone,
    :website,
    :zip

  class << self
    def construct_from(json)
      Mapper.from_json(json || "")
    end

    def retrieve(number:, session:)
      response = HTTP
        .headers({
          :accept => "application/json",
          "X-AgreementGrantToken" => session.agreement_grant_token,
          "X-AppSecretToken" => session.app_secret_token
        })
        .get(
          "https://restapi.e-conomic.com/customers/#{number}"
        )
      construct_from(response.body.to_s)
    end
  end
end
