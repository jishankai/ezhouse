class Customer
  include Mongoid::Document
  include Mongoid::Document

  store_in collection: "customers"

  field :mobile, type: String
end
