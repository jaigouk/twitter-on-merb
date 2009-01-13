namespace :merb do
  namespace :cache do
    desc "clear the caches"
    task :clear do
      FileUtils.rm_rf(Merb.root / :cache / :actions)
      FileUtils.rm_rf(Merb.root / :cache / :fragments)
      FileUtils.rm_rf(Merb.root / 'public' / 'page_cache')
    end
  end
end
