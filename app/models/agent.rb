# coding: utf-8
class Agent
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Search

  store_in collection: "agents"

  field :tx, type: String
  field :name, type: String
  field :mobile, type: String
  field :company, type: String
  field :city, type: String
  field :district, type: String
  field :region, type: String
  field :percentile, type: Integer

  # 链家
  field :position, type: String
  field :commissions, type:Integer
  field :transactions, type:Integer
  field :visits, type:Integer
  field :rates, type:Integer
  field :comments, type:Integer
  field :community, type: String
  field :label, type: String

  # 我爱我家
  field :sales, type:Integer
  field :rents, type:Integer
  field :followers, type:Integer
  field :clicks, type:Integer

  # 麦田
  field :career, type:Integer
  field :customers, type:Integer
  field :stars, type:Integer

  scope :lianjia, ->{ where(company: "链家") }
  scope :wawj, ->{ where(company: "我爱我家") }
  scope :maitian, ->{ where(company: "麦田") }

  scope :districted, ->(district){ where(district: district) }

  #search_in :city, :district, :region, :community
end
