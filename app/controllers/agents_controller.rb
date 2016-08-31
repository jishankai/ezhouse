# coding: utf-8
class AgentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:call]
  layout "apps", :only =>  :edit

  def_param_group :agent do
  end
  def intro
    set_meta_tags title: '经纪人'
    set_meta_tags default_meta_tags
  end
  def index
    set_meta_tags title: '推荐经纪人'
    set_meta_tags default_meta_tags
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

    respond_to do |format|
      format.html
      format.json {
        render :json => @agents.to_json
      }
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
  param :from, String, :desc => "用户电话（可选）"
  param :id, String, :desc => "经纪人id", :required => true
  param :code, String, :desc => '验证码'
  example " 'success':true, 'statusMsg':'成功'"
  def call
    if session[:customer_mobile].present?
      agent = Agent.find(params[:id])
      @helper = Helper.new(:from=>session[:customer_mobile], :to=>agent.mobile)
      r = @helper.double_call
    else
      if params[:code].present? && session[:verify_time].present? && Time.now - session[:verify_time] <= 300 && params[:code]==session[:code]
        c = Customer.find_by mobile: params[:from]
        if c.nil?
          c = Customer.new( :mobile => params[:from] )
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

    if r['statusCode'] == '000000'
      render :json => {:success => true}
    else
      render :json => {:errorCode => r['statusCode'], :errorMsg => r['statusMsg'], :success => false}
    end
  end

  def show
    @agent = Agent.find(params[:id])

    if @agent.rates.present? and @agent.followers.present?
      case @agent.company
      when '链家'
        # lianjia_commissions_max = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.where(:commissions.gte=>0, :commissions.lte=>100000).max(:commissions) }
        # lianjia_transactions_max = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.where(:transactions.gte=>0, :transactions.lte=>100000).max(:transactions) }
        # lianjia_visits_max = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.where(:visits.gte=>0, :visits.lte=>100000).max(:visits) }
        # lianjia_rates_max = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.where(:rates.gte=>0, :rates.lte=>100000).max(:rates) }
        # lianjia_reviews_max = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.where(:reviews.gte=>0, :reviews.lte=>100000).max(:reviews) }
        # lianjia_commissions_avg = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.avg(:commissions) }
        # lianjia_transactions_avg = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.avg(:transactions) }
        # lianjia_visits_avg = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.avg(:visits) }
        # lianjia_rates_avg = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.avg(:rates) }
        # lianjia_reviews_avg = Rails.cache.fetch('lianjia_commissions_max', :expires_in => 24.hours) { Agent.lianjia.avg(:reviews) }
        lianjia_commissions_max = Agent.lianjia.where(:commissions.gte=>0, :commissions.lte=>100000).max(:commissions)
        lianjia_transactions_max = Agent.lianjia.where(:transactions.gte=>0, :transactions.lte=>100000).max(:transactions)
        lianjia_visits_max = Agent.lianjia.where(:visits.gte=>0, :visits.lte=>100000).max(:visits)
        lianjia_rates_max = Agent.lianjia.where(:rates.gte=>0, :rates.lte=>100000).max(:rates)
        lianjia_reviews_max = Agent.lianjia.where(:reviews.gte=>0, :reviews.lte=>100000).max(:reviews)
        lianjia_commissions_avg = Agent.lianjia.avg(:commissions)
        lianjia_transactions_avg = Agent.lianjia.avg(:transactions)
        lianjia_visits_avg = Agent.lianjia.avg(:visits)
        lianjia_rates_avg = Agent.lianjia.avg(:rates)
        lianjia_reviews_avg = Agent.lianjia.avg(:reviews)

        @radar_data = {
          labels: ["成交量", "委托量", "带看量", "好评率", "评论数量"],
          datasets: [
            {
              label: "链家平均值",
              backgroundColor: "rgba(179,181,198,0.2)",
              borderColor: "rgba(179,181,198,1)",
              pointBackgroundColor: "rgba(179,181,198,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(179,181,198,1)",
              data: [cal_percentile(lianjia_commissions_avg, lianjia_commissions_max), cal_percentile(lianjia_transactions_avg, lianjia_transactions_max), cal_percentile(lianjia_visits_avg, lianjia_visits_max), cal_percentile(lianjia_rates_avg, lianjia_rates_max), cal_percentile(lianjia_reviews_avg, lianjia_reviews_max)]
            },
            {
              label: "#{@agent.name}能力值",
              backgroundColor: "rgba(75,183,252,0.2)",
              borderColor: "rgba(75,183,252,1)",
              pointBackgroundColor: "rgba(75,183,252,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(75,183,252,1)",
              data: [cal_percentile(@agent.commissions, lianjia_commissions_max), cal_percentile(@agent.transactions, lianjia_transactions_max), cal_percentile(@agent.visits, lianjia_visits_max), cal_percentile(@agent.rates, lianjia_rates_max), cal_percentile(@agent.reviews, lianjia_reviews_max)]
            }
          ]
        }
      when '我爱我家'
        wawj_sales_max = Agent.wawj.where(:sales.gte=>0, :sales.lte=>100000).max(:sales)
        wawj_rents_max = Agent.wawj.where(:rents.gte=>0, :rents.lte=>100000).max(:rents)
        wawj_followers_max = Agent.wawj.where(:followers.gte=>0, :followers.lte=>100000).max(:followers)
        wawj_rates_max = Agent.wawj.where(:rates.gte=>0, :rates.lte=>100000).max(:rates)
        wawj_clicks_max = Agent.wawj.where(:clicks.gte=>0, :clicks.lte=>100000).max(:clicks)
        wawj_sales_avg = Agent.wawj.avg(:sales)
        wawj_rents_avg = Agent.wawj.avg(:rents)
        wawj_followers_avg = Agent.wawj.avg(:followers)
        wawj_rates_avg = Agent.wawj.avg(:rates)
        wawj_clicks_avg = Agent.wawj.avg(:clicks)

        @radar_data = {
          labels: ["售", "租", "关注量", "好评率", "浏览量"],
          datasets: [
            {
              label: "我爱我家平均值",
              backgroundColor: "rgba(179,181,198,0.2)",
              borderColor: "rgba(179,181,198,1)",
              pointBackgroundColor: "rgba(179,181,198,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(179,181,198,1)",
              data: [cal_percentile(wawj_sales_avg, wawj_sales_max), cal_percentile(wawj_rents_avg, wawj_rents_max), cal_percentile(wawj_followers_avg, wawj_followers_max), cal_percentile(wawj_rates_avg, wawj_rates_max), cal_percentile(wawj_clicks_avg, wawj_clicks_max)]
            },
            {
              label: "#{@agent.name}能力值",
              backgroundColor: "rgba(75,183,252,0.2)",
              borderColor: "rgba(75,183,252,1)",
              pointBackgroundColor: "rgba(75,183,252,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(75,183,252,1)",
              data: [cal_percentile(@agent.sales, wawj_sales_max), cal_percentile(@agent.rents, wawj_rents_max), cal_percentile(@agent.followers, wawj_followers_max), cal_percentile(@agent.rates, wawj_rates_max), cal_percentile(@agent.clicks, wawj_clicks_max)]
            }
          ]
        }
      when '麦田'
        maitian_sales_max = Agent.maitian.where(:sales.gte=>0, :sales.lte=>100000).max(:sales)
        maitian_rents_max = Agent.maitian.where(:rents.gte=>0, :rents.lte=>100000).max(:rents)
        maitian_followers_max = Agent.maitian.where(:followers.gte=>0, :followers.lte=>100000).max(:followers)
        maitian_customers_max = Agent.maitian.where(:customers.gte=>0, :customers.lte=>100000).max(:customers)
        maitian_commissions_max = Agent.maitian.where(:commissions.gte=>0, :commissions.lte=>100000).max(:commissions)
        maitian_sales_avg = Agent.maitian.avg(:sales)
        maitian_rents_avg = Agent.maitian.avg(:rents)
        maitian_followers_avg = Agent.maitian.avg(:followers)
        maitian_customers_avg = Agent.maitian.avg(:customers)
        maitian_commissions_avg = Agent.maitian.avg(:commissions)

        @radar_data = {
          labels: ["在售", "在租", "粉丝数量", "服务客户数", "近期成交量"],
          datasets: [
            {
              label: "麦田平均值",
              backgroundColor: "rgba(179,181,198,0.2)",
              borderColor: "rgba(179,181,198,1)",
              pointBackgroundColor: "rgba(179,181,198,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(179,181,198,1)",
              data: [cal_percentile(maitian_sales_avg, maitian_sales_max), cal_percentile(maitian_rents_avg, maitian_rents_max), cal_percentile(maitian_followers_avg, maitian_followers_max), cal_percentile(maitian_customers_avg, maitian_customers_max), cal_percentile(maitian_commissions_avg, maitian_commissions_max)]
            },
            {
              label: "#{@agent.name}能力值",
              backgroundColor: "rgba(75,183,252,0.2)",
              borderColor: "rgba(75,183,252,1)",
              pointBackgroundColor: "rgba(75,183,252,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(75,183,252,1)",
              data: [cal_percentile(@agent.sales, maitian_sales_max), cal_percentile(@agent.rents, maitian_rents_max), cal_percentile(@agent.followers, maitian_followers_max), cal_percentile(@agent.customers, maitian_customers_max), cal_percentile(@agent.commissions, maitian_commissions_max)]
            }
          ]
        }
      else
      end
    end
    @options = {
      responsive: true,
      animation: {
        animateScale: true,
      }
    }
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  private

  def agent_params
    params.require(:agent).permit(:tx, :name, :company, :city, :district, :region, :community)
  end

  def cal_percentile(a, b)
    return a*100/b
  end

end
