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

    options = {
      mobiles: '18611715161',
      sign_name: '注册验证',
      template_code: 'SMS_11440195',
      params: {
        code: '1220',
        product: '易房好介'
      }
    }

    r = Alidayu::Sms.send(options)
    respond_to do |format|
      format.html
      format.json { render json: {'result' => 1 }}
    end
  end

  def user_params
    params.require(:user).permit(:mobile, :password)
  end
end
