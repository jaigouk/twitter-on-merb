require 'rubygems'
require 'rufus/scheduler'
require 'merb'
require  File.join( File.dirname(__FILE__) + '/../', 'config', 'dependencies.rb')
require  File.join( File.dirname(__FILE__) + '/../', 'application.rb')
    
scheduler = Rufus::Scheduler.start_new

#scheduler.in("3d") do
#  regenerate_monthly_report()
#end

 scheduler.every "5m" do
   TwitterOnMerb.scrape
 end

# scheduler.every "15m" do
#  FileUtils.rm_rf(Merb.root / :cache / :actions)
#  FileUtils.rm_rf(Merb.root / :cache / :fragments)
#  FileUtils.rm_rf(Merb.root / 'public' / 'page_cache')
# end


 scheduler.join # join the scheduler (prevents exiting)

