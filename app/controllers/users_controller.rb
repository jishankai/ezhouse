# coding: utf-8
class UsersController < ApplicationController
  def login
    set_meta_tags title: '登录'
    set_meta_tags default_meta_tags

    if request.post?
      @user = User.find_by mobile: params[:user][:mobile], password: params[:user][:password]
    end
    if @user
      session[:user_id] = @user.id
      redirect_to user_url(@user, format: :html)
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def logout
    if session[:user_id]
      session[:user_id] = nil
    end

    redirect_to root_path
  end

  def new
    set_meta_tags title: '注册'
    set_meta_tags default_meta_tags

    @user = User.new
  end

  def show
    @user = User.find params[:id]

    if @user
      redirect_to agent_url(@user.agent)
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def create
    @user = User.new(user_params)
    @user.save

    redirect_to users_sign_in_url(format: :html)
  end

  def edit
    @user = User.find(params[:id])
  end

  def sms
    mobile = params[:mobile]
    # result = Alidayu::Sms.send_code_for_sign_up(mobile, {code: '1314520'}, '')

    respond_to do |format|
      format.html
      format.json { render json: {'result' => 1 }}
    end
  end

  def user_params
    params.require(:user).permit(:mobile, :password)
  end
end
