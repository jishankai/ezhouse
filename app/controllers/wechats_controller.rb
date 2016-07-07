class WechatsController < ActionController::Base
  wechat_responder

  on :text do |request, content|
    request.reply.text "#{content}" # Just echo
  end
end
