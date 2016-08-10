# coding: utf-8
module Api
  module V1
    class UsersController < ApplicationController
      # 動作確認用にCSRFを無効化しています
      skip_before_action :verify_authenticity_token

      api :POST, "/api/v1/users/check_code", "验证码验证"
      param :comment, Hash, :desc => "验证内容" do
        param :code, String, :desc => "四位验证码", :required => true
      end
      param :user, Hash, :desc => "验证内容" do
        param :code, String, :desc => "四位验证码", :required => true
      end
      param :helper, Hash, :desc => "验证内容" do
        param :code, String, :desc => "四位验证码", :required => true
      end
      def check_code
        if params[:user].present?
          code = params[:user][:code]
        elsif params[:helper].present?
          code = params[:helper][:code]
        elsif params[:comment].present?
          code = params[:comment][:code]
        else
        end

        respond_to do |format|
          format.json { render :json => session[:verify_time].present? && Time.now - session[:verify_time] <= 300 && code == session[:code]}
        end
      end
    end
  end
end
