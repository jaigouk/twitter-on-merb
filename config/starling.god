God.watch do |w|
  w.name = 'starlingd'
  w.interval = 30.seconds
 
  # I do NOT specify the -d parameter which daemonizes beanstalkd.
  # I do this so God can make it a daemon for me!
  w.start = "starling -P tmp/pids/starling.pid -q tmp/starling"
 
  w.start_if do |start|
    start.condition(:process_running) do |p|
      p.interval = 5.seconds
      p.running = false
    end
  end
end
