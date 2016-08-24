# coding: utf-8
module Api
  module V1
    class AgentsController < ApplicationController
      # 動作確認用にCSRFを無効化しています
      skip_before_action :verify_authenticity_token

      api :POST, "/api/v1/agents/search", "搜索经纪人"
      param :major, String, :desc => "类别(sale, rent, agents)", :required => true
      param :arg, String, :desc => '搜索内容', :required => true

      def search
        case params[:major]
        when "sale"
          lianjia_agent = Agent.lianjia.or( {city: params[:arg]}, {district: /.*#{params[:arg]}.*/}, {region: /.*#{params[:arg]}.*/}, {community: /.*#{params[:arg]}.*/} ).and( {major: '买卖'}).order_by(:percentile => -1).first
          wawj_agent = Agent.wawj.or( {city: params[:arg]}, {district: /.*#{params[:arg]}.*/}, {region: /.*#{params[:arg]}.*/}, {community: /.*#{params[:arg]}.*/} ).and( {major: '买卖'}).order_by(:percentile => -1).first
          maitian_agent = Agent.maitian.or( {city: params[:arg]}, {district: /.*#{params[:arg]}.*/}, {region: /.*#{params[:arg]}.*/}, {community: /.*#{params[:arg]}.*/} ).and( {major: '买卖'}).order_by(:percentile => -1).first

          @agents = [lianjia_agent, wawj_agent, maitian_agent].compact
        when "rent"
          lianjia_1st = Agent.lianjia.where( {major:'租赁'} ).order_by(:percentile => -1).first
          wawj_1st = Agent.wawj.where( {major:'租赁'} ).order_by(:percentile => -1).first
          maitian_1st = Agent.maitian.where( {major:'租赁'} ).order_by(:percentile => -1).first

          lianjia_agent = Agent.lianjia.or( {city: params[:arg]}, {district: /.*#{params[:arg]}.*/}, {region: /.*#{params[:arg]}.*/}, {community: /.*#{params[:arg]}.*/} ).and( {major: '租赁'}).order_by(:percentile => -1).first
          wawj_agent = Agent.wawj.or( {city: params[:arg]}, {district: /.*#{params[:arg]}.*/}, {region: /.*#{params[:arg]}.*/}, {community: /.*#{params[:arg]}.*/} ).and( {major: '租赁'}).order_by(:percentile => -1).first
          maitian_agent = Agent.maitian.or( {city: params[:arg]}, {district: /.*#{params[:arg]}.*/}, {region: /.*#{params[:arg]}.*/}, {community: /.*#{params[:arg]}.*/} ).and( {major: '租赁'}).order_by(:percentile => -1).first

          lianjia_agent.percentile = lianjia_agent.percentile*100/lianjia_1st.percentile if lianjia_agent.present?
          wawj_agent.percentile = wawj_agent.percentile*100/wawj_1st.percentile if wawj_agent.present?
          maitian_agent.percentile = maitian_agent.percentile*100/maitian_1st.percentile if maitian_agent.present?

          @agents = [lianjia_agent, wawj_agent, maitian_agent].compact
        when "agents"
          @agents = Agent.or( {mobile: params[:arg]}, {name: params[:arg]} )
        else
        end

        render :json => @agents.to_json
      end

    end
  end
end
