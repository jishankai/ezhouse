class AgentsController < ApplicationController
  def index
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
    @agent = Agent.or( {mobile: params[:arg]}, {name: params[:arg]} ).first

    respond_to do |format|
      format.html
    end
  end
end
