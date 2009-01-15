class Twitteronmerb
  attr_reader :ports, :server_names

  def initialize
    @ports = [5000, 5001]
    @server_names = "merb.kicks-ass.org" 

  end
end

@apps << Twitteronmerb.new
