# coding: utf-8
class Message < ApplicationMailer
  default from: "ehero.cc@qq.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message.tickets.subject
  #
  def tickets(info)
    @info = info
    mail(
      to:      'ehero.cc@qq.com',
      subject: "单身票报名#{@info}",
    ) do |format|
      format.html
    end
  end
end
