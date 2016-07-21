# coding: utf-8
class HelperController < ApplicationController
  def index
  end

  def create
    @helper = Helper.new(helper_params)
    if @helper.code.present? && session[:verify_time].present? && Time.now - session[:verify_time] <= 60 && @helper.code==session[:code]
      r = @helper.double_call
    else
      r = {'statusCode'=>'100001', 'statusMsg'=>'验证码不正确'}
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
