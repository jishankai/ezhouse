# coding: utf-8
class HelperController < ApplicationController
  layout "apps"
  def index
    set_meta_tags title: '免扰电话'
    set_meta_tags default_meta_tags
  end

  def create
    @helper = Helper.new(helper_params)
    if session[:customer_mobile].present?
      @helper.from = session[:customer_mobile]
      r = @helper.double_call
    else
      if @helper.code.present? && session[:verify_time].present? && Time.now - session[:verify_time] <= 300 && @helper.code==session[:code]
        c = Customer.find_by mobile: params[:helper][:from]
        if c.nil?
          c = Customer.new( :mobile => params[:helper][:from] )
          c.save
        end
        session[:customer_id] = c.id
        session[:customer_mobile] = c.mobile
        r = @helper.double_call
      else
        r = {'statusCode'=>'100001', 'statusMsg'=>'验证码不正确'}
      end
    end
    if r['statusCode'] == '000000'
      render :json => {:success => true}
    else
      render :json => {:errorCode => r['statusCode'], :errorMsg => r['statusMsg'], :success => false}
    end
  end

  private

  def helper_params
    params.require(:helper).permit(:from, :to, :code)
  end
end
