
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
  w.name = 'merb-mongrel'
  w.interval = 30.seconds
   w.group = 'merb'

  w.start = "nohup merb -a mongrel -c 1 -m /home/deploy/repos/merb.kicks-ass.org/current -p 4000 -e production "

  w.stop =  "merb -m /home/deploy/repos/merb.kicks-ass.org/current -k all"

  w.behavior(:clean_pid_file)
  generic_monitoring(w, :cpu_limit => 60.percent, :memory_limit => 150.megabytes)
end

