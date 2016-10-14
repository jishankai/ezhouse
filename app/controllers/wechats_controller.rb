# coding: utf-8
class WechatsController < ActionController::Base
  wechat_responder

  # on :text do |request, content|
  #   request.reply.text "#{content}" # Just echo
  # end

  on :text, with: /^[男|女]\ \d+\ \d{11}\ \d+$/ do |request|
    #Message.tickets(request[:Content]).deliver_now
    Mail.deliver do
      to ENV['marketing_mail_address']
      from 'marketing@ehero.cc'
      subject "单身狗报名 #{request[:Content]}"
      body "#{request[:Content]}"
    end
    request.reply.text "非常感谢参与抽奖，你猜的数一定很大吧？！/::P

把赠话剧票活动分享到朋友圈，让大家帮你早日达到目标，并与白富美或高富帅配对！"
  end

  on :text, with: '群主' do |request|
    request.reply.image('wfjD9PAgZwMe__i0uqLCnpyLQYZ5a3wJap4GhWGfIJg')
  end

  on :event, with: 'subscribe' do |request|
    request.reply.text "您好，欢迎您关注易房好介!

“易房好介”是一个大数据房产经纪人匹配平台，旨在为租房者与买房者提供更好的房产交易环境。您成为了易房好介第一批的种子用户！

平台在测试阶段，您目前可以免费试用“免扰电话”功能，如果您很喜欢，欢迎推荐给朋友~如果觉得哪里做的不够好，更欢迎您在公众号后台与我们沟通改进！

【租房微信群】

回复“群主”，进入【大学生］，［北漂］或［地区］租房群"
  end

  on :click, with: 'ABOUTUS' do |request, key|
    request.reply.text "我们是一家互联网房地产创业公司，致力于帮助客户找到最匹配的房屋与经纪人。"
  end

  on :click, with: 'APP' do |request, key|
    request.reply.image("K-J-wJ-o3NlCf6QCW1AcVUMjex2PCDBDbAV8t9i6jm7OeXosOuCx779TRhVf0nt-")
  end

  on :click, with: 'GROUPS' do |request, key|
    request.reply.text "回复“群主”，进入【大学生］，［北漂］或［地区］租房群"
  end

  on :click, with: 'HELP' do |request, key|
    request.reply.text "您好，欢迎您关注易房好介!

“易房好介”是一个大数据房产经纪人匹配平台，旨在为租房者与买房者提供更好的房产交易环境。您成为了易房好介第一批的种子用户！

平台在测试阶段，您目前可以免费试用“免扰电话”功能，如果您很喜欢，欢迎推荐给朋友~如果觉得哪里做的不够好，更欢迎您在公众号后台与我们沟通改进！

【租房微信群】

回复“群主”，进入【大学生］，［北漂］或［地区］租房群"
  end
end
