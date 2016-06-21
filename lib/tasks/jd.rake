# coding: utf-8
require 'csv'

namespace :jd do
  desc "获取京东商品信息"
  task :fetch, [:f, :o] => :environment do |t, args|
    AGENTPATTERN = %r[http://item.jd.com/\d+.html]
    begin
      arr_of_arrs = CSV.read(args[:f], :headers=>true)

      of = args[:o]
      if File.exists?(of)
        offset = `wc -l #{of}`.to_i
      else
        offset = 0
      end
      codes_of_jd = arr_of_arrs['京东SKU'].drop(offset)
      urls_of_jd = codes_of_jd.map { |x| "http://item.jd.com/" + x.to_s + ".html" }

      #urls_of_jd = arr_of_arrs['京东单品页面'].drop(offset)
      #byebug
      @sheet = []

      Anemone.crawl(urls_of_jd, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0, :discard_page_bodies => true}) do |anemone|
        #anemone.storage = Anemone::Storage.Redis(:url=>'redis://127.0.0.1:6379/2/anemone')
        anemone.focus_crawl do |page|
          page.links.keep_if { |link|
            link.to_s.match(AGENTPATTERN)
          }
        end
        i = 0
        anemone.on_every_page do |page|
          puts page.url
          @url = page.url
          row = {}
          row[:code] = page.url.to_s.gsub!(/\D/, "")
          row[:name] = page.doc.xpath('//*[@id="name"]/h1').text

          json_price = JSON.load(open('http://p.3.cn/prices/mgets?type=1&skuIds=J_'+row[:code]))
          row[:discount] = json_price[0]["p"]
          row[:price] = json_price[0]["m"]

          @sheet.push(row)
          i += 1
          CSV.open(of, "ab") do |csv|
            @sheet.each do |hash|
              csv << hash.values
            end
            @sheet.clear
          end if i % 10 == 0 or i == urls_of_jd.size
        end
      end
    rescue => e
      Rails.logger.error { "#{@url} #{e.message} \n" }
      retry
    end

    puts `ponysay #{args[:url]} 搞定啦`
  end

end
