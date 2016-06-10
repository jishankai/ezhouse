class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :agent

  after_save :sync_agent

  store_in collection: "users"

  field :mobile, type: String
  field :code, type: Integer
  field :password, type: String

  protected

  def sync_agent
    agent = Agent.find_by mobile: self.mobile.to_i
    if agent
      self.create_agent(agent.attributes.except(:_id, :created_at))
    else
      self.create_agent
    end
    self.agent.save!
  end
end
