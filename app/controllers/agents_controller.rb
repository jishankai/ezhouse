# coding: utf-8
class AgentsController < ApplicationController
  layout "users", :only =>  :edit

  def_param_group :agent do
  end
  def intro
    set_meta_tags title: '经纪人'
    set_meta_tags default_meta_tags
  end
  def index
    @agents = params[:agents]
  end
  api :GET, "/agents/search", "搜索地区"
  param :address, String
  def search
    set_meta_tags title: '推荐经纪人'
    set_meta_tags default_meta_tags

    lianjia_agent = Agent.lianjia.or( {city: params[:address]}, {district: params[:address]}, {region: params[:address]}, {community: /.*#{params[:address]}.*/} ).order_by(:percentile => -1).first
    wawj_agent = Agent.wawj.or( {city: params[:address]}, {district: params[:address]}, {region: params[:address]}, {community: /.*#{params[:address]}.*/} ).order_by(:percentile => -1).first
    maitian_agent = Agent.maitian.or( {city: params[:address]}, {district: params[:address]}, {region: params[:address]}, {community: /.*#{params[:address]}.*/} ).order_by(:percentile => -1).first

    @agents = [lianjia_agent, wawj_agent, maitian_agent].compact

    respond_to do |format|
      format.html
      format.json {
        render :json => @agents.to_json
      }
    end
  end

  api :GET, "/agents/asearch", "搜索经纪人"
  param :arg, String
  def asearch
    set_meta_tags title: '搜索经纪人'
    set_meta_tags default_meta_tags

    @agents = Agent.or( {mobile: params[:arg]}, {name: params[:arg]} )

    if @agents.size == 1
      redirect_to agent_path(@agents.first)
    else
      respond_to do |format|
        format.html
        format.json {
          render :json => @agents.to_json
        }
      end
    end
  end

  api!
  def update
    if current_user.agent.update_attributes(agent_params)
      flash[:success] = "更新成功！"
      redirect_to agent_path
    else
      flash[:error] = "更新失败！"
      redirect_to agent_path
    end
  end

  api!
  def show
    set_meta_tags title: '经纪人资料'
    set_meta_tags default_meta_tags

    @agent = Agent.find(params[:id])
  end

  api :POST, "/agents/call", "呼叫经纪人"
  param :mobile, String, :desc => "用户电话（可选）"
  param :id, String, :desc => "经纪人id", :required => true
  example " 'success':true, 'statusMsg':'成功'"
  def call
    if session[:customer_mobile].present?
      agent = Agent.find(params[:id])
      @helper = Helper.new(:from=>session[:customer_mobile], :to=>agent.mobile)
      r = @helper.double_call
    else
      if params[:code].present? && session[:verify_time].present? && Time.now - session[:verify_time] <= 300 && params[:code]==session[:code]
        c = Customer.find_by mobile: params[:mobile]
        if c.nil?
          c = Customer.new( :mobile => params[:mobile] )
          c.save
        end
        session[:customer_id] = c.id
        session[:customer_mobile] = c.mobile
        agent = Agent.find(params[:id])
        @helper = Helper.new(:from=>session[:customer_mobile], :to=>agent.mobile)
        r = @helper.double_call
      else
        r = {'statusCode'=>'100001', 'statusMsg'=>'验证码不正确'}
      end
    end

    r = @helper.double_call
    if r['statusCode'] == '000000'
      render :json => {:success => true}
    else
      render :json => {:errorCode => r['statusCode'], :errorMsg => r['statusMsg'], :success => false}
    end
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def agent_params
    params.require(:agent).permit(:tx, :name, :company, :city, :district, :region, :community)
  end

end
