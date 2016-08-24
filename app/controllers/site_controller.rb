# coding: utf-8
class SiteController < ApplicationController
  def index
    set_meta_tags title: '首页'
    set_meta_tags default_meta_tags

    agents_group_by_company = Agent.collection.aggregate([{'$group' => {'_id' => '$company', 'count' => {'$sum' => 1 }}}])
    @agents_company_summary = {}
    agents_group_by_company.each do |agbc|
      @agents_company_summary[agbc[:_id]] = agbc[:count]
    end

    @data = {
      labels: ["January", "February", "March", "April", "May", "June", "July"],
      datasets: [
        {
          label: "My First dataset",
          backgroundColor: "rgba(220,220,220,0.2)",
          borderColor: "rgba(220,220,220,1)",
          data: [65, 59, 80, 81, 56, 55, 40]
        },
        {
          label: "My Second dataset",
          backgroundColor: "rgba(151,187,205,0.2)",
          borderColor: "rgba(151,187,205,1)",
          data: [28, 48, 40, 19, 86, 27, 90]
        }
      ]
    }
    @options = {
      responsive: true
    }
  end
end
