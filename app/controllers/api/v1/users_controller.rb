# coding: utf-8
module Api
  module V1
    class UsersController < ApplicationController
      # 動作確認用にCSRFを無効化しています
      skip_before_action :verify_authenticity_token

      api :GET, "/api/v1/users/check_code", "验证码验证"
      param :code, String, :desc => "四位验证码", :required => true
      def check_code
        code = params[:code]

        respond_to do |format|
          format.json { render :json => session[:verify_time].present? && Time.now - session[:verify_time] <= 300 && code == session[:code]}
        end
      end

      def slides
        slides = YAML.load(File.open(Rails.root.join("public/slides.yml")))

        render json: slides
      end
    end
  end
end
