desc "This task is called by the Heroku scheduler add-on"
task :update_tips => :environment do
  Tip.where(:available=>1).each do |tip|
    tip.update(:clicks=>tip.clicks+rand(10))
  end
end
