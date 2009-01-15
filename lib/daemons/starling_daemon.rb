#!/usr/bin/env ruby
require 'rubygems'
require 'merb'
require File.dirname(__FILE__) + '/../../config/dependencies'
load_paths = []
load_paths.unshift(File.join(Merb.root , '/models'))

load_paths.each do |path|
  Dir.glob("#{path}/*").each { |m| require m }
end


$running = true
Signal.trap("TERM") do
  $running = false
end

require 'twitter/console'
require 'memcache'
gem('twitter4r', '0.3.0')
require 'twitter'
require 'time'
require 'open-uri'
require 'daemons'

sleep_time = 0
starling = MemCache.new('127.0.0.1:22122')
config_file = File.join(Merb.root,  'config', 'twitter.yml')

while($running) do
  message = starling.get('twitter_post')
  if message
    @post_client = Twitter::Client.from_config(config_file, 'user' )
#    @post_client = Twitter::Client.new('edgemerb', 'merbonrails')

    begin
      status =@post_client.status(:post, message[:send])
    rescue Exception
      print 'X'
      starling.set('twitter_post', message)
      sleep_time = 30
    end
  else #no work
    print '.'
    sleep_time = 5
  end
  $stdout.flush
  sleep sleep_time
end #loop end

