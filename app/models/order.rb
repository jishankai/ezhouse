class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "orders"

  field :out_trade_no, type: String
  field :subject, type: String
  field :total_fee, type: String
  field :trade_status, type: Integer
  field :trade_no, type: String
  field :notify_time, type: DateTime
  field :seller_email, type: String
  field :buyer_email, type: String
  field :seller_id, type: String
  field :buyer_id, type: String
  field :user_id, type: String
  field :user_name, type: String
  field :user_mobile, type: String
  field :user_type, type: Integer
end
