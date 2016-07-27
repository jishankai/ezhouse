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

  on :text, with: '北漂' do |request|
    request.reply.image('wfjD9PAgZwMe__i0uqLCnvg-9yhkCGMhhjJMnD8BoZE')
  end
  on :text, with: '大学生' do |request|
    request.reply.image('wfjD9PAgZwMe__i0uqLCnjinACcdGbbZpHs4RzrsEEo')
  end
  on :text, with: '地区' do |request|
    request.reply.text "请访问http://ehero-info.sxl.cn获取地区群二维码列表"
  end

  on :event, with: 'subscribe' do |request|
    request.reply.text "您好，欢迎您关注易房好介~
“易房好介”是一个大数据房产经纪人匹配平台，旨在为租房者与买房者提供更好的房产交易环境。
平台在测试阶段，您目前可以免费试用“免扰电话”功能，如果您很喜欢，欢迎推荐给朋友~如果觉得哪里做的不够好，更欢迎您在公众号后台与我们沟通改进！

【租房微信群】
回复“北漂”，进入【北漂租房大群】

回复“大学生”，进入【北京大学生租房合租信息群】

回复“地区”，进入【按地区划分租房微信群】"
  end

  on :click, with: 'ABOUTUS' do |request, key|
    request.reply.text "易房好介（http://ehero.cc）是一家互联网房地产创业公司，致力于帮助客户找到最匹配的房屋与经纪人。
公司已拿到百万级的种子投资。团队成员来自芝加哥大学，清华，北大，浙大等名校，并均有海外工作背景。
种子投资人与顾问团队包括清华统计学教授，高盛高管与量化基金经理等。

公司地址：五道口清华科技园内
商业合作请发邮件至杨阳洋（lyang419@gmail.com）
技术合作请发邮件至季多宝（jishankai@qq.com）"
  end

  on :click, with: 'HELP' do |request, key|
    request.reply.text "公众号功能正着急开发中，您可以访问我们的网站http://ehero.cc"
  end
end
