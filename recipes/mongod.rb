directory "/etc/mongodb" do
  owner "mongodb"
  group "mongodb"
  mode "0775"
  recursive true
end

mongodb_defaults = {
  :mongod => {
    :version => '2.2.3',
    :bind_ip => '127.0.0.1',
    :port => 27017,
    :pidfile => "/var/lib/mongodb/mongod.lock",
    :timeout => 300,
    :dbpath => "/var/lib/mongodb",
    :logpath => "/var/log/mongodb",
    :bin => "/usr/bin/mongod"
  },
  :mongos => {
    :bind_ip => '127.0.0.1',
    :port => 27017,
    :timeout => 300,
    :logpath => "/var/log/mongodb",
    :bin => "/usr/bin/mongos"
  }
}

node[:mongodb][:instances].each do | instance |
  attributes = mongodb_defaults[instance[:type].to_sym].clone

  instance.each do |key, val|
    attributes[key.to_sym] = val
  end

  log_dir = attributes[:logpath];
  attributes[:configpath] = "/etc/mongodb/mongodb-#{attributes[:port]}.conf"
  attributes[:logpath] = "#{attributes[:logpath]}/mongodb-#{attributes[:port]}.log"
  attributes[:upstartpath] = "/etc/init/mongodb-#{instance[:port]}.conf"

  template attributes[:upstartpath] do
    source "mongodb.upstart.erb"
    owner "root"
    group "root"
    mode "0644"
    backup false
    variables attributes
    # notifies :restart, resources(:service => "mongodb-#{attributes[:port]}"), :delayed
  end

  service "mongodb-#{attributes[:port]}" do
    provider Chef::Provider::Service::Upstart
    supports :start => true, :stop => true, :restart => true
    action [:enable, :start]
  end

  directory attributes[:dbpath] do
    owner "mongodb"
    group "mongodb"
    mode "0775"
    recursive true
    only_if { attributes.key?(:dbpath) }
  end

  directory log_dir do
    owner "mongodb"
    group "mongodb"
    mode "0775"
    recursive true
  end

  template attributes[:configpath] do
    source "mongodb.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    backup false
    variables attributes
    # notifies :restart, resources(:service => "mongodb-#{attributes[:port]}"), :delayed
  end
end
