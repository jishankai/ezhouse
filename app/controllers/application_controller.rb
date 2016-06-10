class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

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

end
