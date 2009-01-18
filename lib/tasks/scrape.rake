namespace :twitter do
  desc "just scrape it"
  task :getit=>  :merb_env do
    p TwitterOnMerb.scrape
  end
  desc "clear cache"
  task :clear_cache=>  :merb_env do    
      FileUtils.rm_rf(Merb.root / :cache / :actions)
      FileUtils.rm_rf(Merb.root / :cache / :fragments)
      FileUtils.rm_rf(Merb.root / 'public' / 'page_cache')
  end
end
