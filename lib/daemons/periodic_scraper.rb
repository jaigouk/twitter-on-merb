#!/usr/bin/env ruby

#$running = true
#Signal.trap("TERM") do
#  $running = false
#end
# 
require 'rufus/scheduler'
#require 'daemons'
#begin
  scheduler ||= Rufus::Scheduler.start_new

#  while($running) do
    scheduler.every "30m" do
      Tweet.scrape
      Merb.logger.info("#{Time.now} scraping started")
    end
    scheduler.every "1h" do
      FileUtils.rm_rf(Merb.root / :cache / :actions)
      FileUtils.rm_rf(Merb.root / :cache / :fragments)
      FileUtils.rm_rf(Merb.root / 'public' / 'page_cache')
    end
    scheduler.join 
#  end #loop end
#rescue => e 
#  Merb.logger.warn "scheduler failed! -- #{Time.now}"
#end   
   

  

