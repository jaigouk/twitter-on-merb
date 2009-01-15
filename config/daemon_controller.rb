require 'daemon_controller'

#class Starling server
#  def initialize
#  @controller = DaemonController.new(
  controller = DaemonController.new(
     :identifier    => 'Starling server',
     :start_command => 'starling -d -P tmp/pids/starling.pid -q tmp/starling',
     :ping_command  => lambda { TCPSocket.new('localhost', 22122) },
     :pid_file      => 'starling.pid',
   :  log_file      => 'starling.log')
#end
#  def start
#    @controller.start
    controller.start
#  end
#  
#  def stop
#    @controller.stop
#  end

