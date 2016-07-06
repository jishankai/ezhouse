class WechatsController < ActionController::Base
  wechat_responder

  on :text do |request, content|
    request.reply.text "echo: #{content}" # Just echo
  end
end
