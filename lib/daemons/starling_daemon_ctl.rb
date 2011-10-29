require 'rubygems'
require 'daemons'

starling_client = File.join(File.dirname(__FILE__), "starling_consumer.rb")

options = {
  :dir_mode => :normal,
  :dir => File.join(File.dirname(__FILE__), "..", "..", "log"),
  :ARGV => ARGV,
  :log_output => true,
  :multiple => false,
  :backtrace => true,
  :monitor => false
}

Daemons.run(starling_client, options)


# ruby starling_daemon_ctl.rb start
