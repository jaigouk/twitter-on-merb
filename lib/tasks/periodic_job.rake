namespace :chores do
#    require 'memcache'

    desc "Scrapes on every 30 min"
    task :evenry30minutes =>  :merb_env do
    chore("Every 30 minutes") do
      p Tweet.scrape
    end
  end

  desc "Scrapes on every hour"
  task :hourly =>  :merb_env   do
    chore("Hourly") do
      # Your Code Here
    end
  end
  desc "Clear cache on every day"
  task :daily  =>  :merb_env do
    chore("Daily") do
      FileUtils.rm_rf(Merb.root / :cache / :actions)
      FileUtils.rm_rf(Merb.root / :cache / :fragments)
      FileUtils.rm_rf(Merb.root / 'public' / 'page_cache')
    end
  end
  desc "Scrapes on every week"
  task :weekly  =>  :merb_env do
    chore("Weekly") do
      # Your Code Here
    end
  end
  
  def chore(name)
    puts "#{name} Task Invoked: #{Time.now}"
    yield
    puts "#{name} Task Finished: #{Time.now}"
  end



end
