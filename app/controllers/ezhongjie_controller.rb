class EzhongjieController < ApplicationController
	layout 'application'

  def index
    set_meta_tags title: '易中介'
    set_meta_tags default_meta_tags
  end
end
