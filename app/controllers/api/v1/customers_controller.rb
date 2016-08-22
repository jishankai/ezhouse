# coding: utf-8
module Api
  module V1
    class CustomersController < ApplicationController
      # 動作確認用にCSRFを無効化しています
      skip_before_action :verify_authenticity_token

      api :POST, "/api/v1/customers/call", "免扰电话"
      param :helper, Hash, :desc => "电话数据", :required => true do
        param :from, String, :desc => "用户电话", :required => true
        param :code, String, :desc => "验证码（若已验证过号码则可留空）"
        param :to, String, :desc => "对方号码", :required => true
      end
      def call
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

      api!
      def groups
        groups = YAML.load(File.open(Rails.root.join("public/groups.yml")))

        render json: groups
      end

      private

      def helper_params
        params.require(:helper).permit(:from, :to, :code)
      end
    end
  end
end
