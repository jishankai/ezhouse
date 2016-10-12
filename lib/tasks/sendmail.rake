
require 'csv'

namespace :sendmail do

  desc "发送广告邮件"
  task :mail_advrt do
  	arr_of_arrs = CSV.read('filename.csv', headers: true)

    arr_of_arrs.each do |data|
      arr_mail=data["mail"]
      arr_user=data["user"]

      Mail.deliver do
      to arr_mail
      from 'marketing@ehero.cc'
      subject ""
      body "#{request[:Content]}"
      end

    
    end
  end
end
