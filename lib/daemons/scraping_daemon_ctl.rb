require 'rubygems'
require 'daemons'

scheduler= File.join(File.dirname(__FILE__), "scraping_scheduler.rb")
  
options = {
  :dir_mode => :normal,
  :dir => File.join(File.dirname(__FILE__), "..", "..", "log"),
  :ARGV => ARGV,
  :log_output => true,
  :multiple => false,
  :backtrace => true,
  :monitor => false
}
 
Daemons.run(scheduler, options)
 
 
# ruby starling_daemon_ctl.rb start
