class HelperController < ApplicationController
  def index
  end

  def create
    @helper = Helper.new(helper_params)
    r = @helper.double_call
  end

  private

  def helper_params
    params.require(:helper).permit(:from, :to)
  end
end
