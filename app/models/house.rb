class House
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  embedded_in :agent

  store_in collection: "houses"

  field :thumbs, :type => String
  field :title, :type => String
  field :price, :type => String
  field :description, :type => String
  field :model, :type => String
  field :area, :type => String
  field :toward, :type => String
  field :type, :type => String
  field :floor, :type => String
  field :clicks, :type => Integer
  field :unit_price, :type => String
  field :location, :type => String
  field :followers, :type => Integer
end
