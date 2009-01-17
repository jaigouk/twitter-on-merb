require 'rubygems'
require 'rufus/scheduler'
require 'merb'
require  File.join( File.dirname(__FILE__) + '/../', 'config', 'dependencies.rb')
require  File.join( File.dirname(__FILE__) + '/../', 'application.rb')
    
require 'rubygems'
require 'daemons'
require 'rufus/scheduler'
 
scheduler = File.join(File.dirname(__FILE__), 'scheduler.rb')
options = {
  :app_name => 'scheduler',
  :ARGV => ARGV,
  :dir_mode => :normal,
  :dir => 'log',
  :log_output => true,
  :multiple => true,
  :backtrace => true,
  :monitor => true
}
 
Daemons.run(scheduler, options)
 
require File.dirname(__FILE__) + '/../config/environment'
RAILS_DEFAULT_LOGGER.auto_flushing = 1
 
Thread.abort_on_exception = true
 
class Scheduler
  def start
    scheduler = Rufus::Scheduler.start_new
    class << scheduler
      def log_exception (e)
        ActiveRecord::Base.logger.warn(
          "#{Time.now} !! something went wrong : #{e}")
      end
    end
    scheduler.every '10s' do
      logger.info "#{Time.now} doin stuff now!"
    end
    scheduler.join
  end
  def logger
    ActiveRecord::Base.logger
  end
end
 
puts 'Scheduler starting.'
Scheduler.new.start
 
