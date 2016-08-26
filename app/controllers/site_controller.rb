# coding: utf-8
class SiteController < ApplicationController
  def index
    set_meta_tags title: '首页'
    set_meta_tags default_meta_tags

    agents_group_by_company = Agent.collection.aggregate([{'$group' => {'_id' => '$company', 'count' => {'$sum' => 1 }}}])
    count_summary = []
    company_summary = []
    agents_group_by_company.each do |agbc|
      if agbc[:_id].present?
        count_summary << agbc[:count]
        company_summary << agbc[:_id]
      end
    end
    @agents_data = {
      datasets: [{
                   data: count_summary,
                   backgroundColor: [
                     "#4BC0C0",
                     "#FFCE56",
                     "#FF6384",
                     "#36A2EB"
                   ],
                   label: '推荐经纪人分布'
                 }],
      labels: company_summary
    }
    @agents_options = {
      responsive: true,
      animation: {
        animateScale: true,
      }
    }

    tips_group_by_district = Tip.collection.aggregate([{'$group' => {'_id' => '$district', 'count' => {'$sum' => '$clicks'}}}])
    tips_count_summary = []
    tips_district_summary = []
    tips_group_by_district.each do |tgbc|
      if tgbc[:_id].present?
        tips_count_summary << tgbc[:count]
        tips_district_summary << tgbc[:_id]
      end
    end

    @tips_data = {
      labels: tips_district_summary,
      datasets: [
        {
          label: "锦囊下载量分布",
          backgroundColor: [
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)',
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)',
            'rgba(255, 99, 132, 0.2)',
            'rgba(255, 206, 86, 0.2)',
          ],
          borderColor: [
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(255,99,132,1)',
            'rgba(255, 206, 86, 1)',
          ],
          borderWidth: 1,
          data: tips_count_summary
        }
      ]
    }
    @tips_options = {
      responsive: true,
      animation: {
        animateScale: true,
      }
    }

    transactions_summary = Agent.lianjia.avg(:transactions)
    commissions_summary = Agent.lianjia.avg(:commissions)
    visits_summary = Agent.lianjia.avg(:visits)

    @summary_data = {
      datasets: [{
                   data: [transactions_summary, commissions_summary, visits_summary],
                   backgroundColor: [
                     "#4BC0C0",
                     "#FFCE56",
                     "#FF6384",
                   ],
                   label: '经纪人关键数据'
                 }],
      labels: ['平均委托量', '平均交易量', '平均带看量']
    }
    @summary_options = {
      responsive: true,
      animation: {
        animateScale: true,
      }
    }

  end
end
