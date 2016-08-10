# coding: utf-8
module Api
  module V1
    class UsersController < ApplicationController
      # 動作確認用にCSRFを無効化しています
      skip_before_action :verify_authenticity_token

    end
  end
end
