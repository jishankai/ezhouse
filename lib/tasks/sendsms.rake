# coding: utf-8
require 'csv'

namespace :sendsms do
  
  desc "发送广告信息"
  task :sms_advrt do
    arr_of_arrs = CSV.read('agents.csv', headers: true)

    arr_of_arrs.each do |data|
      arr_mobile = data["mobile"]
      arr_user = data["user"]

      params = {
        to: arr_mobile,
        templateId: '',
        datas: arr_user,
      }

      Sms.send(params)
    
    end
  end

end
