# coding: utf-8
class SiteController < ApplicationController
  def index
    set_meta_tags title: '首页'
    set_meta_tags default_meta_tags
    Mail.deliver do
      to 'ehero.cc@qq.com'
      from 'marketing@ehero.cc'
      subject "单身狗报名"
      body ""
    end
   end
end
