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
dependency "dm-core", dm_gems_version 

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
dependency 'nokogiri'
dependency 'shorturl'
dependency 'god'
dependency 'daemons'

gem('twitter4r', '0.3.0')
require 'twitter'
require 'time'
require 'open-uri'
require 'memcache'
