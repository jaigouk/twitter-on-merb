require 'twitter/console'
config_file = File.join(Merb.root,  'config', 'twitter.yml')

namespace :starling do
  desc "consume twitter messages to send"
  task :consume do
    require 'memcache'
    gem('twitter4r', '0.3.0')
    require 'twitter'
    require 'time'
    require 'open-uri'
    
    sleep_time = 0
    starling = MemCache.new('127.0.0.1:22122')
    
    loop do 
      message = starling.get('twitter_post')
      if message
        @post_client = Twitter::Client.from_config(config_file, 'user' )

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
  end
end
