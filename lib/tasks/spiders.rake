# coding: utf-8
require 'csv'

namespace :spiders do
  desc "获取链家中介信息"
  task :lfetch, [:url, :n, :region] => :environment do |t, args|
    n = args[:n].to_i
    i = *(1..n)
    urls = i.map { |x| args[:url] + x.to_s }
    @sheet = []

    Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 1}) do |anemone|
      #anemone.storage = Anemone::Storage.Redis
      PATTERN = %r[#{args[:url]+'\\d+'}]
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(PATTERN)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        page.doc.search('ul.agent-lst li').each do |r|
          row = {}
          row[:img] = r.search('img').attribute('src').value
          row[:name] = r.search('.agent-name h2').text
          row[:position] = r.search('span.position').text
          row[:plate] = ""
          r.search('.main-plate span a').each do |m|
            row[:plate] += m.text
            row[:plate] += " "
          end
          row[:achievement] = ""
          r.search('.achievement span').each do |a|
            row[:achievement] += a.text
            row[:achievement] += " "
          end
          row[:label] = ""
          r.search('.label span').each do |l|
            row[:label] += l.text
            row[:label] += " "
          end
          row[:rates] = r.search('.high-praise span.num').text
          row[:votes] = r.search('.comment-num').text
          row[:mobile] = r.search('.col-3 h2').text
          row[:url] = r.search('.agent-name a').attribute('href').value
          #byebug
          @sheet.push(row)
        end
      end
    end
    f = "/Users/jishankai/Desktop/链家经纪人_"+args[:region]+"_"+@sheet.size.to_s+"_utf8.csv"
    CSV.open(f, "wb") do |csv|
      csv << ["照片", "姓名", "职位", "主营板块", "数据", "标签", "好评率", "评论数量", "电话", "链接"]
      @sheet.each do |hash|
        csv << hash.values
      end
    end
  end

  desc "获取我爱我家中介信息"
  task :wfetch, [:url, :n, :region] => :environment do |t, args|
    n = args[:n].to_i
    i = *(1..n)
    urls = i.map { |x| args[:url] + x.to_s }
    @sheet = []
    Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0}) do |anemone|
      #anemone.storage = Anemone::Storage.Redis
      PATTERN = %r[#{args[:url]+"\\d+"}]
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(PATTERN)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        page.doc.search('.zhiye_content .consinfo').each do |r|
          row = {}
          row[:image] = r.search('dl.leftfuwusty dt img').attribute('src').value
          row[:name] = r.search('.conts_left span').text
          row[:mobile] = r.search('.conts_left b').text
          row[:plate] = ""
          r.search('dl.leftfuwusty dd a.mr5').each do |p|
            row[:plate] += p.text
            row[:plate] += " "
          end
          row[:community] = ""
          r.search('dl.leftfuwusty dd.asty a').each do |c|
            row[:community] += c.text
            row[:community] += " "
          end
          row[:sale] = r.search('dl.leftfuwusty dd.shouzu span.f3d').text
          row[:rent] = r.search('dl.leftfuwusty dd.shouzu span.fcf0').text
          row[:rates] = r.search('dl.leftfuwusty dd.pinglunxin b').count
          row[:followers] = r.search('dl.leftfuwusty dd.guanzhudu span').first.text
          row[:clicks] = r.search('dl.leftfuwusty dd.guanzhudu span').last.text
          row[:url] = r.search('dl.leftfuwusty dt a').attribute('href').value

          @sheet.push(row)
          #byebug
        end
      end
    end
    f = "/Users/jishankai/Desktop/我爱我家经纪人_"+args[:region]+"_"+@sheet.size.to_s+".csv"
    CSV.open(f, "wb") do |csv|
      csv << ["照片", "姓名", "电话", "商圈", "小区", "售", "租", "好评度", "关注度", "点击量", "链接"]
      @sheet.each do |hash|
        csv << hash.values
      end
    end
  end

  desc "获取我爱我家中介信息"
  task :wfetch2, [:url, :n, :region] => :environment do |t, args|
    n = args[:n].to_i
    i = *(1..n)
    urls = i.map { |x| args[:url] + x.to_s }
    @sheet = []
    Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0}) do |anemone|
      #anemone.storage = Anemone::Storage.Redis
      PATTERN = %r[#{args[:url]+"\\d+"}]
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(PATTERN)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        page.doc.search('ul.agentlist').each do |r|
          row = {}
          row[:image] = r.search('li.agent-left img').attribute('src').value
          row[:name] = r.search('li.agent-content li.agentname a').text
          row[:mobile] = r.search('li.phoneno p').text
          row[:plate] = ""
          r.search('li.shangquan').first.search('a').each do |p|
            row[:plate] += p.text
            row[:plate] += " "
          end
          row[:community] = ""
          r.search('li.shuxixq a').each do |c|
            row[:community] += c.text
            row[:community] += " "
          end
          row[:sale] = r.search('li.agent-content ul li.f-neme').text
          #row[:rent] = r.search('dl.leftfuwusty dd.shouzu span.fcf0').text
          row[:rates] = r.search('li.comments img').count
          row[:followers] = r.search('li.shangquan span').first.text
          row[:clicks] = r.search('li.shangquan span').last.text
          row[:url] = r.search('li.agent-content li.agentname a').attribute('href').value

          @sheet.push(row)
          #byebug
        end
      end
    end
    f = "/Users/jishankai/Desktop/我爱我家经纪人_"+args[:region]+"_"+@sheet.size.to_s+".csv"
    CSV.open(f, "wb") do |csv|
      csv << ["照片", "姓名", "电话", "商圈", "小区", "售租", "好评度", "关注度", "点击量", "链接"]
      @sheet.each do |hash|
        csv << hash.values
      end
    end
  end

  desc "获取麦田中介信息"
  task :mfetch, [:url, :n, :region] => :environment do |t, args|
    n = args[:n].to_i
    i = *(1..n)
    urls = i.map { |x| args[:url] + x.to_s }
    @sheet = []
    Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0}) do |anemone|
      #anemone.storage = Anemone::Storage.Redis
      PATTERN = %r[#{args[:url]+"\\d+"}]
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(PATTERN)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        page.doc.search('ul.bj_agent_list li.clearfix').each do |r|
          row = {}
          row[:image] = r.search('img').attribute('src').value
          row[:name] = r.search('.sale_points_author h6 a').text
          row[:mobile] = r.search('.sale_points_author h6 span').text
          row[:plate] = r.search('.sale_points_author p').first.search('span').text.gsub!(/\s/, "")
          row[:sale] = r.search('.sale_points_author p')[1].search('span a').first.text
          row[:rent] = r.search('.sale_points_author p')[1].search('span a').last.text
          row[:label] = ""
          r.search('dl dd mark').each do |l|
            row[:label] += l.text
            row[:label] += " "
          end
          row[:years] = r.search('.sale_points_list p span').first.text
          row[:customers] = r.search('.sale_points_list p span')[1].text
          row[:deal] = r.search('.sale_points_list p span')[2].text
          row[:followers] = r.search('.sale_points_list p span').last.text
          row[:stars] = r.search('.agent_star_box em.agent_star_light').count

          @sheet.push(row)
        end
      end
    end
    f = "/Users/jishankai/Desktop/ehero/麦田经纪人_"+args[:region]+"_"+@sheet.size.to_s+".csv"
    CSV.open(f, "wb") do |csv|
      csv << ["照片", "姓名", "电话", "商圈", "售", "租", "标签", "从业年限", "客户数", "近期成交", "粉丝数", "星级"]
      @sheet.each do |hash|
        csv << hash.values
      end
    end

    puts `ponysay #{args[:url]} GAMEOVER`
  end

  desc "获取麦田中介信息"
  task :mfetch2, [:url, :n, :region] => :environment do |t, args|
    n = args[:n].to_i
    i = *(1..n)
    urls = i.map { |x| args[:url] + x.to_s }
    @sheet = []
    Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0}) do |anemone|
      #anemone.storage = Anemone::Storage.Redis
      PATTERN = %r[#{args[:url]+"\\d+"}]
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(PATTERN)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        page.doc.search('.list_wrap li.clearfix').each do |r|
          row = {}
          row[:image] = r.search('img').attribute('src').value
          row[:name] = r.search('.sale_points_author h6 a').text
          row[:mobile] = r.search('.sale_points_author h6 span').text
          row[:plate] = r.search('.sale_points_author p').first.search('span').last.text.gsub!(/\s/, "")
          row[:community] = r.search('.sale_points_author p')[1].search('span').last.text
          row[:label] = ""
          r.search('dl dd mark').each do |l|
            row[:label] += l.text
            row[:label] += " "
          end
          row[:sale] = r.search('.sale_points_list p span').first.text
          row[:visits] = r.search('.sale_points_list p span')[1].text
          row[:followers] = r.search('.sale_points_list p span').last.text
          row[:stars] = r.search('.agent_star_box em.agent_star_light').count
          @sheet.push(row)
        end
      end
    end
    f = "/Users/jishankai/Desktop/ehero/麦田经纪人_"+args[:region]+"_"+@sheet.size.to_s+".csv"
    CSV.open(f, "wb") do |csv|
      csv << ["照片", "姓名", "电话", "商圈", "小区", "标签", "待售", "近期带看", "粉丝数", "星级"]
      @sheet.each do |hash|
        csv << hash.values
      end
    end

    puts `ponysay #{args[:url]} GAMEOVER`
  end

  desc "获取21世纪不动产中介信息"
  task :cfetch, [:url, :n, :region] => :environment do |t, args|
    n = args[:n].to_i
    i = *(1..n)
    urls = i.map { |x| args[:url] + x.to_s }
    @sheet = []
    Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0}) do |anemone|
      #anemone.storage = Anemone::Storage.Redis
      PATTERN = %r[#{args[:url]+"\\d+"}]
      anemone.focus_crawl do |page|
        page.links.keep_if { |link|
          link.to_s.match(PATTERN)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        page.doc.search('.agent_list li.cur').each do |r|
          row = {}
          row[:image] = r.search('.agent_img img').attribute('src').value
          row[:name] = r.search('.agent_txt .agent_name b a').text
          row[:mobile] = r.search('.agent_txt p span').text
          row[:shop] = r.search('.agent_txt p').first.text
          row[:plate] = r.search('.agent_txt p a').text
          row[:stars] = r.search('.agent_txt .agent_name img').attribute('src').value
          row[:url] = r.search('.agent_txt .agent_name b a').attribute('href').value
          @sheet.push(row)
        end
      end
    end
    f = "/Users/jishankai/Desktop/ehero/21世纪经纪人_"+args[:region]+"_"+@sheet.size.to_s+".csv"
    CSV.open(f, "wb") do |csv|
      csv << ["照片", "姓名", "电话", "店名", "地区", "星级", "链接"]
      @sheet.each do |hash|
        csv << hash.values
      end
    end

    puts `ponysay #{args[:url]} GAMEOVER`
  end

  desc "删除中介信息"
  task erase: :environment do
    puts `ponysay ERASE`
  end

  desc "更新链家中介信息"
  task :lupdate, [:url, :split] => :environment do |t, args|
    AGENTPATTERN = %r[http://\d+.dianpu.lianjia.com]
    # i = *(1..100)
    # urls = i.map { |x| args[:url] + x.to_s }
    # s = []
    # Anemone.crawl(urls, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0}) do |anemone|
    #   #anemone.storage = Anemone::Storage.Redis
    #   PATTERN = %r[#{args[:url]+'\d+'}]
    #   anemone.focus_crawl do |page|
    #     page.links.keep_if { |link|
    #       link.to_s.match(PATTERN)
    #     }
    #   end

    #   anemone.on_every_page do |page|
    #     u = [] # 经纪人个人页面URL集合
    #     puts page.url
    #     page.doc.search('ul.agent-lst li').each do |r|
    #       u.push(r.search('.agent-name a').attribute('href').value)
    #     end
    #     #byebug
    #     s.push(u)
    #   end
    # end
    begin
      f = "/Users/jishankai/Desktop/ehero/链家各地经纪人/链家经纪人_" + args[:url] + ".csv"
      # CSV.open(f, "wb") do |csv|
      #   s.each do |arr|
      #     csv << arr
      #   end
      # end

      arr_of_arrs = CSV.read(f, :headers=>true)
      # urls_of_agents = arr_of_arrs.flatten(1)

      f = "/Users/jishankai/Desktop/ehero/链家各地经纪人/链家经纪人_手机_"+args[:url]+".csv"
      if File.exists?(f)
        offset = `wc -l #{f}`.to_i
      else
        offset = 0
      end
      urls_of_agents = arr_of_arrs['链接'].drop(offset)
      @sheet = []

      # CSV.open(f, "wb") do |csv|
      #   csv << ["姓名", "手机", "小区", "链接"]
      # end
      # byebug
      Anemone.crawl(urls_of_agents, {:user_agent => "AnemoneCrawler/0.0.1", :delay => 1, :depth_limit => 0, :discard_page_bodies => true}) do |anemone|
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
          row[:name] = page.doc.xpath('/html/body/div[6]/div/div[1]/div[1]/div[1]/div[2]/div[1]/a[1]/h1').text
          row[:mobile] = page.doc.xpath('/html/head/title').text.gsub!(/\D/, "")
          raise "302" if row[:mobile] == "302"
          #row[:name] = page.doc.search('.agent-name a h1').text
          #row[:mobile] = page.doc.at('title').inner_html.gsub!(/\D/, "")
          row[:community] = ""
          #page.doc.search('.info_bottom p').last.search('a').each do |r|
          page.doc.xpath('/html/body/div[6]/div/div[1]/div[1]/div[2]/p[3]').search('a').each do |r|
            row[:community] += r.text
            row[:community] += " "
          end
          if (page.doc.xpath('/html/body/div[6]/div/div[1]/div[2]/div/ul/li[4]').empty?)
            row[:type] = '租赁'
          else
            row[:type] = '买卖'
          end
          row[:url] = page.url.to_s
          # byebug
          @sheet.push(row)
          i += 1
          CSV.open(f, "ab") do |csv|
            @sheet.each do |hash|
              csv << hash.values
            end
            @sheet.clear
          end if i % args[:split].to_i == 0 or i == urls_of_agents.size
        end
      end
    rescue => e
      Rails.logger.error { "#{@url} #{e.message} \n" }
      retry
    end

    puts `ponysay #{args[:url]} GAMEOVER`
  end

end
