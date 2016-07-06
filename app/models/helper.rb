class Helper
  include Mongoid::Document

  field :from, type: String
  field :to, type: String

  def double_call
    params = {
      :from => from,
      :to => to
    }

    YunTongXun::Voice.double_call(params)
  end
end
