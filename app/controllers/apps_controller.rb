# coding: utf-8
class AppsController < ApplicationController
  layout 'application'

  def index
    set_meta_tags title: 'APP下载'
    set_meta_tags default_meta_tags
  end
end
