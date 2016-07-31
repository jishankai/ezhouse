# coding: utf-8
class UsersController < ApplicationController
  def_param_group :user do
    param :user, Hash do
      param :mobile, String
      param :password, String
    end
  end

  api :POST, "/users/login", "登录"
  param_group :user
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

  api!
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

  api :POST, "/users/create", "创建用户"
  param_group :user
  def create
    @user = User.new(user_params)
    @user.save

    render :json => {:success => true}
  end

  def edit
    @user = User.find(params[:id])
  end

  def reset
    set_meta_tags title: '登录'
    set_meta_tags default_meta_tags

    if request.put?
      @user = User.find_by mobile: params[:user][:mobile]
      @user.update(user_params)
    end

    respond_to do |format|
      format.html
      format.json { render :json => { :success => true } }
    end
  end

  api :POST, "/users/sms", "短信验证"
  param :mobile, String, :desc => "用户电话", :required => true
  example " 'result'=>1 "
  def sms
    if session[:verify_time].nil? || Time.now - session[:verify_time] > 60
      mobile = params[:mobile]
      code = (1000+rand(8999)).to_s
      session[:code] = code
      session[:verify_time] = Time.now
      case params[:type]
      when 'register'
        sign_name = '注册验证'
        template_code = 'SMS_11440195'
      when 'verify'
        sign_name = '身份验证'
        template_code = 'SMS_11440199'
      else
        sign_name = '身份验证'
        template_code = 'SMS_11440199'
      end

      options = {
        mobiles: mobile,
        sign_name: sign_name,
        template_code: template_code,
        params: {
          code: code,
          product: '易房好介'
        }
      }

      r = Alidayu::Sms.send(options)
    end
    respond_to do |format|
      format.html
      format.json { render json: {'result' => 1 }}
    end
  end

  def check_user
    @user = User.find_by mobile: params[:user][:mobile]

    respond_to do |format|
      format.json { render :json => !!@user }
    end
  end

  def check_mobile
    @user = User.find_by mobile: params[:user][:mobile]

    respond_to do |format|
      format.json { render :json => !@user }
    end
  end

  def check_code
    if params[:user].present?
      code = params[:user][:code]
    elsif params[:helper].present?
      code = params[:helper][:code]
    elsif parmas[:comment].present?
      code = params[:comment][:code]
    else
    end

    respond_to do |format|
      format.json { render :json => session[:verify_time].present? && Time.now - session[:verify_time] <= 300 && code == session[:code]}
    end
  end

  def user_params
    params.require(:user).permit(:mobile, :password)
  end
end
