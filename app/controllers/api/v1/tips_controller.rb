# coding: utf-8
module Api
  module V1
    class TipsController < ApplicationController
      # 動作確認用にCSRFを無効化しています
      skip_before_action :verify_authenticity_token

      def index
        render json: Tip.all
      end

      api!
      def regions
        regions = YAML.load(File.open(Rails.root.join("public/tips.yml")))

        render json: regions
      end
    end
  end
end
