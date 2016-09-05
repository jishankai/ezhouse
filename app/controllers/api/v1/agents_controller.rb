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

      def show
        @agent = Agent.find(params[:id])

        render :json => @agent
      end

      def average
        @agent = {}
        @agent['lianjia_commissions_max'] = Agent.lianjia.where(:commissions.gte=>0, :commissions.lte=>100000).max(:commissions)
        @agent['lianjia_transactions_max'] = Agent.lianjia.where(:transactions.gte=>0, :transactions.lte=>100000).max(:transactions)
        @agent['lianjia_visits_max'] = Agent.lianjia.where(:visits.gte=>0, :visits.lte=>100000).max(:visits)
        @agent['lianjia_rates_max'] = Agent.lianjia.where(:rates.gte=>0, :rates.lte=>100000).max(:rates)
        @agent['lianjia_reviews_max'] = Agent.lianjia.where(:reviews.gte=>0, :reviews.lte=>100000).max(:reviews)
        @agent['lianjia_commissions_avg'] = Agent.lianjia.avg(:commissions)
        @agent['lianjia_transactions_avg'] = Agent.lianjia.avg(:transactions)
        @agent['lianjia_visits_avg'] = Agent.lianjia.avg(:visits)
        @agent['lianjia_rates_avg'] = Agent.lianjia.avg(:rates)
        @agent['lianjia_reviews_avg'] = Agent.lianjia.avg(:reviews)

        @agent['wawj_sales_max'] = Agent.wawj.where(:sales.gte=>0, :sales.lte=>100000).max(:sales)
        @agent['wawj_rents_max'] = Agent.wawj.where(:rents.gte=>0, :rents.lte=>100000).max(:rents)
        @agent['wawj_followers_max'] = Agent.wawj.where(:followers.gte=>0, :followers.lte=>100000).max(:followers)
        @agent['wawj_rates_max'] = Agent.wawj.where(:rates.gte=>0, :rates.lte=>100000).max(:rates)
        @agent['wawj_clicks_max'] = Agent.wawj.where(:clicks.gte=>0, :clicks.lte=>100000).max(:clicks)
        @agent['wawj_sales_avg'] = Agent.wawj.avg(:sales)
        @agent['wawj_rents_avg'] = Agent.wawj.avg(:rents)
        @agent['wawj_followers_avg'] = Agent.wawj.avg(:followers)
        @agent['wawj_rates_avg'] = Agent.wawj.avg(:rates)
        @agent['wawj_clicks_avg'] = Agent.wawj.avg(:clicks)

        @agent['maitian_sales_max'] = Agent.maitian.where(:sales.gte=>0, :sales.lte=>100000).max(:sales)
        @agent['maitian_rents_max'] = Agent.maitian.where(:rents.gte=>0, :rents.lte=>100000).max(:rents)
        @agent['maitian_followers_max'] = Agent.maitian.where(:followers.gte=>0, :followers.lte=>100000).max(:followers)
        @agent['maitian_customers_max'] = Agent.maitian.where(:customers.gte=>0, :customers.lte=>100000).max(:customers)
        @agent['maitian_commissions_max'] = Agent.maitian.where(:commissions.gte=>0, :commissions.lte=>100000).max(:commissions)
        @agent['maitian_sales_avg'] = Agent.maitian.avg(:sales)
        @agent['maitian_rents_avg'] = Agent.maitian.avg(:rents)
        @agent['maitian_followers_avg'] = Agent.maitian.avg(:followers)
        @agent['maitian_customers_avg'] = Agent.maitian.avg(:customers)
        @agent['maitian_commissions_avg'] = Agent.maitian.avg(:commissions)

        render :json => @agent
      end
    end
  end
end
