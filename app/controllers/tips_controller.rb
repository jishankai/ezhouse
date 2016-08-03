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
end
