#!/usr/bin/env ruby
require 'rubygems'
require 'merb'
#require   File.dirname(__FILE__) + '/../../' + 'config/dependencies.rb'
 require  File.dirname(__FILE__) + '/../../' + 'application.rb' 
 
$running = true
Signal.trap("TERM") do
  $running = false
end
require 'rufus/scheduler'
require 'daemons'

#require File.dirname(__FILE__) + '/../config/environment'
#RAILS_DEFAULT_LOGGER.auto_flushing = 1
 
Thread.abort_on_exception = true
 
class Scheduler
  def start
    scheduler = Rufus::Scheduler.start_new
    
    class << scheduler
      def log_exception (e)
        Merb.logger.info("#{Time.now} !! something went wrong : #{e}")
      end
    end
    
    scheduler.every "5m" do
       TwitterOnMerb.scrape
     end
     
    scheduler.every "30m" do
     TwitterOnMerb.clear_cache
    end 
    
    scheduler.join # join the scheduler (prevents exiting)
  end
  
end
 
