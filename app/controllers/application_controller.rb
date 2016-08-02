# coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :default_meta_tags

  def after_sign_out_path_for resource
    agents_path
  end

  def after_sign_in_path_for resource
    agent_path(resource)
  end

  protected

  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def default_meta_tags
    {
      description: '“易房好介”是一款房地产经纪人搜索平台，我们用大数据推荐最优秀，最匹配的经纪人，帮助客户更有效地看房，同时绕过假房源。',
      keywords:    '房地产，经纪人，中介，搜索，大数据，真实，买卖，租赁',
    }
  end


end
