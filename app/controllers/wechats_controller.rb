# coding: utf-8
class WechatsController < ActionController::Base
  wechat_responder

  # on :text do |request, content|
  #   request.reply.text "#{content}" # Just echo
  # end

  on :event, with: 'subscribe' do |request|
    request.reply.text "谢谢您关注我们的公众号！
易房好介，为您推荐最匹配的房屋和经纪人！
请访问我们正在开发的网站http://ehero.cc，提供您宝贵的意见！"
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
