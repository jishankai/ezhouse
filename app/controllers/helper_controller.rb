class HelperController < ApplicationController
  def index
  end

  def create
    @helper = Helper.new(helper_params)
    r = @helper.double_call
    if r['statusCode'] == '000000'
      render :json => {:success => true}
    else
      render :json => {:errorCode => r['statusCode'], :errorMsg => r['statusMsg'], :success => false}
    end
  end

  private

  def helper_params
    params.require(:helper).permit(:from, :to)
  end
end
