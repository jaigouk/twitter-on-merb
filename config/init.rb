use_orm :datamapper
use_test :rspec
use_template_engine :erb

merb_gems_version = ">=1.0.8.1"
dm_gems_version   = ">=0.9.10"
do_gems_version   = ">=0.9.11"
dependency "merb-core", merb_gems_version 
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency "merb-helpers", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "data_objects", do_gems_version
dependency "dm-core", dm_gems_version         
dependency "dm-aggregates", dm_gems_version
dependency "dm-migrations", dm_gems_version
dependency "dm-timestamps", dm_gems_version
dependency "dm-types", dm_gems_version
dependency "dm-validations", dm_gems_version

dependency "do_mysql", do_gems_version
dependency "dm-core", dm_gems_version 

dependency 'merb-cache', merb_gems_version do 
  Merb::Cache.setup do
    unless defined? CACHE_SETUP
      register(:twitter_fragment_store, Merb::Cache::FileStore, :dir => Merb.root / 'cache' / 'fragments')
      register(:twitter_page_store, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / 'public' / 'page_cache')
      register(:default, Merb::Cache::AdhocStore[:twitter_page_store, :twitter_fragment_store])
#        register(:memcached,  Merb::Cache::MemcachedStore, :namespace => "twitter", :servers => ["127.0.0.1:11211"]) 
   end
   CACHE_SETUP = true
  end
end
require 'nokogiri'
require 'shorturl'
require 'god'
require 'daemons'
require 'starling'
gem('twitter4r', '0.3.0')
require 'twitter'
require 'time'
require 'open-uri'
require 'memcache'
require 'rufus/scheduler'

Merb::BootLoader.before_app_loads do
system 'starling -d -P log/pids/starling.pid -q log/starling_queue'
end

Merb::BootLoader.after_app_loads do

  STARLING = MemCache.new('127.0.0.1:22122') 

end


Merb::Router.prepare do
  match('/').to(:controller => "twitter_on_merb", :action =>'index')
  match('/about').to(:controller => "twitter_on_merb", :action =>'about')
  match('/commits').to(:controller => "twitter_on_merb", :action =>'commits')
  default_routes
end


Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :debug,
  c[:log_stream]          = STDOUT,
  # or use file for logging:
  # c[:log_file]          = Merb.root / "log" / "merb.log",
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_twitter_on_merb_session_id',
  c[:session_secret_key]  = '6f61c1a0968b761a4535f82d9da4619dc2ad461e'
  c[:exception_details]   = true,
  c[:reload_classes]      = true,
  c[:reload_templates]    = true,
  c[:reload_time]         = 0.5
}
