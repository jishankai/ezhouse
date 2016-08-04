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
    filepath = Rails.root.join('public/documents',params[:file_name])
    stat = File::stat(filepath)
    send_file(filepath, :filename => params[:file_name], :length => stat.size)
  end
end
