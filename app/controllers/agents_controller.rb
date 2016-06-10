# coding: utf-8
class AgentsController < ApplicationController
  def intro
  end
  def index
    @agents = params[:agents]
  end
  def search
    @lianjia_agent = Agent.lianjia.or( {city: params[:address]}, {district: params[:address]}, {region: params[:address]}, {community: /.*#{params[:address]}.*/} ).order_by(:percentile => -1).first
    @wawj_agent = Agent.wawj.or( {city: params[:address]}, {district: params[:address]}, {region: params[:address]}, {community: /.*#{params[:address]}.*/} ).order_by(:percentile => -1).first
    @maitian_agent = Agent.maitian.or( {city: params[:address]}, {district: params[:address]}, {region: params[:address]}, {community: /.*#{params[:address]}.*/} ).order_by(:percentile => -1).first

    respond_to do |format|
      format.html
      format.json { render json: { 'lianjia' => @lianjia_agent, 'wawj' => @wawj_agent, 'maitian' => @maitian_agent } }
    end
  end

  def asearch
    @agents = Agent.or( {mobile: params[:arg]}, {name: params[:arg]} )

    if @agents.size == 1
      redirect_to agent_path(@agents.first)
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def update
    if current_user.agent.update_attributes(params[:agent])
      flash[:success] = "更新成功！"
      redirect_to user_path
    else
      flash[:error] = "更新失败！"
      redirect_to user_path
    end
  end

  def show
    @agent = Agent.find(params[:id])
  end
end
