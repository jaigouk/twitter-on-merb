use_orm :datamapper
use_test :rspec
use_template_engine :erb

merb_gems_version = "1.0.7.1"
dm_gems_version   = "0.9.9"
do_gems_version =  "0.9.10.1"
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version
dependency "merb-helpers", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "data_objects", '0.9.10.1'
dependency "dm-aggregates", dm_gems_version
dependency "dm-migrations", dm_gems_version
dependency "dm-timestamps", dm_gems_version
dependency "dm-types", dm_gems_version
dependency "dm-validations", dm_gems_version

dependency "do_mysql", do_gems_version
dependency "do_sqlite3", do_gems_version

#dependency "daemons"
dependency "daemon_controller"
#dependency "merb_daemon"

#dependency "dm-is-searchable", dm_gems_version 

dependency "dm-core", dm_gems_version do
#  DataMapper.setup(:default, "mysql::in_memory")
#  DataMapper.setup(:search, "ferret://#{Pathname(__FILE__).dirname.expand_path.parent + "dbindex"}")
end

dependency 'merb-cache', merb_gems_version do 
  Merb::Cache.setup do
    unless defined? CACHE_SETUP
      register(:twitter_fragment_store, Merb::Cache::FileStore, :dir => Merb.root / 'cache' / 'fragments')
      register(:twitter_page_store, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / 'public' / 'page_cache')
      register(:default, Merb::Cache::AdhocStore[:twitter_page_store, :twitter_fragment_store])
        register(:memcached,  Merb::Cache::MemcachedStore, :namespace => "twitter", :servers => ["127.0.0.1:11211"])
   end
   CACHE_SETUP = true
  end
end

gem('twitter4r', '0.3.0')
require 'twitter'
require 'time'
require 'open-uri'
dependency 'nokogiri'
dependency 'shorturl'
require 'memcache'

Merb::BootLoader.before_app_loads do
#  dev_gems = Dir.glob("#{Merb.root}/gems/development/**/lib/*.rb")
#  dev_gems.each { |dev_gem| require dev_gem }

end

Merb::BootLoader.after_app_loads do

  
  if  STARLING = MemCache.new('127.0.0.1:22122') then
#      require Merb.root + '/config/daemon_controller.rb'
    puts 'starling loaded'
  end

end


    
# Move this to application.rb if you want it to be reloadable in dev mode.
Merb::Router.prepare do
  match('/').to(:controller => "twitter_on_merb", :action =>'index')
  match('/about').to(:controller => "twitter_on_merb", :action =>'about')
  match('/commits').to(:controller => "twitter_on_merb", :action =>'commits')
  default_routes
end

# I copied environments folder from normal app into config folder
Merb::Config.use { |c|

  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_twitter_on_merb_session_id',
  c[:session_secret_key]  = '6f61c1a0968b761a4535f82d9da4619dc2ad461e'

}
