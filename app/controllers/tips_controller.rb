# coding: utf-8
class TipsController < ApplicationController
  def index
    set_meta_tags title: '租房锦囊'
    set_meta_tags default_meta_tags

    @tips = Tip.all
  end

  def show
    set_meta_tags title: '锦囊详情'
    set_meta_tags default_meta_tags

    @tip = Tip.find(params[:id])
  end

  def download
    tip = Tip.find(params[:id])
    tip.update(:clicks=>tip.clicks+1)
    filepath = Rails.root.join('public/documents',tip.route)
    stat = File::stat(filepath)
    send_file(filepath, :filename => tip.route, :length => stat.size)
  end
end
