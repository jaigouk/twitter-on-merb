
MERB_ROOT=File.join( File.dirname(__FILE__) + '/../')
def generic_monitoring(w, options = {})
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = options[:memory_limit]
      c.times = [3, 5] # 3 out of 5 intervals
    end
  
    restart.condition(:cpu_usage) do |c|
      c.above = options[:cpu_limit]
      c.times = 5
    end
  end
  
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

God.watch do |w|
  w.name = 'start_starling'
  w.interval = 30.seconds
   w.group = 'twitter'
  # I do NOT specify the -d parameter which daemonizes beanstalkd.
  # I do this so God can make it a daemon for me!
  w.start = "/usr/local/bin/starling -d -P #{MERB_ROOT}/log/starling.pid -q #{MERB_ROOT}/log/"
  w.stop =  "kill `cat #{MERB_ROOT}/log/starling.pid`"
  w.pid_file = "#{MERB_ROOT}/log/starling.pid"
  w.behavior(:clean_pid_file)
  generic_monitoring(w, :cpu_limit => 70.percent)
end

God.watch do |w|
  w.name = "consumer"
  w.interval = 60.seconds
  w.group = "twitter"
  w.start = "ruby #{MERB_ROOT}/lib/daemons/starling_daemon_ctl.rb start"
  w.restart = "ruby #{MERB_ROOT}/lib/daemons/starling_daemon_ctl.rb restart"
  w.stop = "ruby #{MERB_ROOT}/lib/daemons/starling_daemon_ctl.rb stop"
  
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{MERB_ROOT}/log/consumer.pid"
  
  w.behavior(:clean_pid_file)
  generic_monitoring(w, :cpu_limit => 70.percent)
end
