# coding: utf-8

require 'csv'

namespace :sendmail do

  desc "发送广告邮件"
  task :mail_advrt do
    arr_of_arrs = CSV.read('lib/tasks/mails.csv', headers: true)

    arr_of_arrs.each do |data|
      arr_mail = data["mail"]
      arr_user = data["user"]

      Mail.deliver do

        to arr_mail
        from 'marketing@ehero.cc'
        subject "【全球首发】国内第一个中介大数据搜索评价平台，让您对黑中介假房源说再见"

        html_part do
          content_type 'text/html;charset=UTF-8'
          body "易房好介是一个中介搜索平台，用科学的算法和多维度数据为您提供最准确的置业建议。<a href='http://ehero.cc/site/advert'>服务体验地址</a>"
        end
      end

      puts arr_mail
    end
  end
end
