class Tip
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "tips"

  field :name, type: String
  field :thumb, type: String
  field :city, type: String
  field :district, type: String
  field :route, type: String
  field :description, type: String
  field :author, type: String
  field :version, type: String
  field :available, type: Boolean
  field :clicks, type: Integer
end
