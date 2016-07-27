# coding: utf-8
class SiteController < ApplicationController
  def index
    set_meta_tags title: '首页'
    set_meta_tags default_meta_tags
  end
end
