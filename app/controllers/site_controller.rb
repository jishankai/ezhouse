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

    @options = {
      responsive: true
    }
  end
end
