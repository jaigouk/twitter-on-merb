#!/usr/bin/env ruby
require 'rubygems'
#require 'merb'
require 'nokogiri'
require 'shorturl'
require 'god'
require 'daemons'

gem('twitter4r', '0.3.0')
require 'twitter'
require 'time'
require 'open-uri'
require 'memcache'
require 'rufus/scheduler'
#require File.join( File.dirname(__FILE__) +'/../../', 'config', 'dependencies.rb')
#require File.join( File.dirname(__FILE__) + '/../../', 'models', 'tweet.rb')


$running = true
Signal.trap("TERM") do
  $running = false
end
 
require 'rufus/scheduler'
require 'daemons'
begin
  scheduler ||= Rufus::Scheduler.start_new

  while($running) do
    scheduler.every "25m" do
      Tweet.scrape
      Merb.logger.info("#{Time.now} scraping started")
    end
    scheduler.every "30m" do
      FileUtils.rm_rf(Merb.root / :cache / :actions)
      FileUtils.rm_rf(Merb.root / :cache / :fragments)
      FileUtils.rm_rf(Merb.root / 'public' / 'page_cache')
    end
    scheduler.join 
  end #loop end
rescue => e 
  Merb.logger.warn "scheduler failed! -- #{Time.now}"
end   
   

  

