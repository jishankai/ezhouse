# coding: utf-8
namespace :agents do
  desc "经纪人排名"
  task sort: :environment do
    # 链家排名计算
    @commissions_sorted = Agent.lianjia.order_by(:commissions => -1).pluck(:commissions)
    @transactions_sorted = Agent.lianjia.order_by(:transactions => -1).pluck(:transactions)
    @visits_sorted = Agent.lianjia.order_by(:visits => -1).pluck(:visits)
    @rates_sorted = Agent.lianjia.order_by(:rates => -1).pluck(:rates)
    @reviews_sorted = Agent.lianjia.order_by(:reviews => -1).pluck(:reviews)

    @agents_size = @commissions_sorted.size
    Agent.lianjia.no_timeout.each do |agent|
      commissions_index = @commissions_sorted.index(agent.commissions)
      transactions_index = @transactions_sorted.index(agent.transactions)
      visits_index = @visits_sorted.index(agent.visits)
      rates_index = @rates_sorted.index(agent.rates)
      reviews_index = @reviews_sorted.index(agent.reviews)

      commissions_index = commissions_index.nil? ? @agents_size : commissions_index
      transactions_index = transactions_index.nil? ? @agents_size : transactions_index
      visits_index = visits_index.nil?  ? @agents_size : visits_index
      rates_index = rates_index.nil?  ? @agents_size : rates_index
      reviews_index = reviews_index.nil? ?  @agents_size : reviews_index

      # 50% 5% 15% 15% 15%
      percentile = 100 - (commissions_index*50 + transactions_index*5 + visits_index*15 + rates_index*15 + reviews_index*15)/@agents_size
      agent.update(percentile: percentile)
      puts "#{agent.name} #{agent.company} #{agent.region}"
    end

    $redis.set('lianjia_agents', Agent.lianjia.order_by(:percentile => -1).as_json)

    # 我爱我家排名计算
    @sales_sorted = Agent.wawj.order_by(:sales => -1).pluck(:sales)
    @rents_sorted = Agent.wawj.order_by(:rents => -1).pluck(:rents)
    @rates_sorted = Agent.wawj.order_by(:rates => -1).pluck(:rates)
    @followers_sorted = Agent.wawj.order_by(:followers => -1).pluck(:followers)
    @clicks_sorted = Agent.wawj.order_by(:clicks => -1).pluck(:clicks)

    @agents_size = @sales_sorted.size
    Agent.wawj.no_timeout.each do |agent|
      sales_index = @sales_sorted.index(agent.sales)
      rents_index = @rents_sorted.index(agent.rents)
      rates_index = @rates_sorted.index(agent.rates)
      followers_index = @followers_sorted.index(agent.followers)
      clicks_index = @clicks_sorted.index(agent.clicks)

      sales_index = sales_index.nil? ? @agents_size : sales_index
      rents_index = rents_index.nil? ? @agents_size : rents_index
      rates_index = rates_index.nil? ? @agents_size : rates_index
      followers_index = followers_index.nil? ? @agents_size : followers_index
      clicks_index = clicks_index.nil? ? @agents_size : clicks_index

      # 40% 35% 5% 10% 10%
      percentile = 100 - (sales_index*40 + rents_index*35 + rates_index*5 + followers_index*10 + clicks_index*10) / @agents_size
      agent.update(percentile: percentile)
      puts "#{agent.name} #{agent.company} #{agent.region}"
    end

    $redis.set('wawj_agents', Agent.wawj.order_by(:percentile => -1).as_json)

    # 麦田排名计算
    @sales_sorted = Agent.maitian.order_by(:sales => -1).pluck(:sales)
    @rents_sorted = Agent.maitian.order_by(:rents => -1).pluck(:rents)
    @career_sorted = Agent.maitian.order_by(:career => -1).pluck(:career)
    @customers_sorted = Agent.maitian.order_by(:customers => -1).pluck(:customers)
    @commissions_sorted = Agent.maitian.order_by(:commissions => -1).pluck(:commissions)
    @followers_sorted = Agent.maitian.order_by(:followers => -1).pluck(:followers)
    @stars_sorted = Agent.maitian.order_by(:stars => -1).pluck(:stars)

    @agents_size = @sales_sorted.size
    Agent.maitian.no_timeout.each do |agent|
      sales_index = @sales_sorted.index(agent.sales)
      rents_index = @rents_sorted.index(agent.rents)
      career_index = @career_sorted.index(agent.career)
      customers_index = @customers_sorted.index(agent.customers)
      commissions_index = @commissions_sorted.index(agent.commissions)
      followers_index = @followers_sorted.index(agent.followers)
      stars_index = @stars_sorted.index(agent.stars)

      sales_index = sales_index.nil? ? @agents_size : sales_index
      rents_index = rents_index.nil? ? @agents_size : rents_index
      career_index = career_index.nil? ? @agents_size : career_index
      customers_index = customers_index.nil? ? @agents_size : customers_index
      commissions_index = commissions_index.nil? ? @agents_size : commissions_index
      followers_index = followers_index.nil? ? @agents_size : followers_index
      stars_index = stars_index.nil? ? @agents_size : stars_index

      #30% 2% 10% 20% 30% 5% 3%
      percentile = 100 - (sales_index*30 + rents_index*2 + career_index*10 + customers_index*20 + commissions_index*30 + followers_index*5 + stars_index*3) / @agents_size
      agent.update(percentile: percentile)
      puts "#{agent.name} #{agent.company} #{agent.region}"
    end

    $redis.set('maitian_agents', Agent.wawj.order_by(:percentile => -1).as_json)
  end

end
