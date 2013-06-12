mongod_defaults = {
  :version => '2.2.3',
  :bind_ip => '127.0.0.1',
  :port => 27017,
  :pidfile => "/var/lib/mongodb/mongod.lock",
  :timeout => 300,
  :dbpath => "/var/lib/mongodb",
  :logpath => "/var/log/mongodb",
  :bin => "/usr/bin/mongod"
}

mongos_defaults = mongod_defaults
mongos_defaults[:bin] = "/usr/bin/mongos"

# The version that we'll install via apt
default[:mongodb][:instances] = []
default[:mongodb][:mongod] = mongod_defaults


# How often to logrotate:
# * daily
# * weekly
# * monthly
default[:mongodb][:logrotate][:period] = "daily"
#
# How many archived logfiles to keep
default[:mongodb][:logrotate][:keep] = 7
