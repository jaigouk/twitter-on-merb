
merb_gems_version = "1.0.8"
dm_gems_version   = "0.9.10"
do_gems_version =  "0.9.11"
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version
dependency "merb-helpers", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "data_objects", do_gems_version
dependency "dm-aggregates", dm_gems_version
dependency "dm-migrations", dm_gems_version
dependency "dm-timestamps", dm_gems_version
dependency "dm-types", dm_gems_version
dependency "dm-validations", dm_gems_version

dependency "do_mysql", do_gems_version
dependency "do_sqlite3", do_gems_version
dependency "dm-core", dm_gems_version 

dependency 'merb-cache', merb_gems_version
dependency 'nokogiri', '1.1.1'
dependency 'shorturl', '0.8.4'
dependency 'god', '0.7.12'
dependency 'daemons', '1.0.10'

dependency 'twitter4r', '0.3.0'
dependency 'twitter', '0.4.1'
dependency  'memcache-client', '1.6.0'
dependency  'memcached', '0.12'
dependency  'fiveruns-memcache-client', '1.5.0.5'
dependency 'rufus-scheduler', '1.0.12'
