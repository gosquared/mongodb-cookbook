node[:instances].each do |instance|
  instance = node[:mongodb][:mongod].merge(instance)

  service "mongodb-#{instance[:port]}" do
    provider Chef::Provider::Service::Upstart
    supports :start => true, :stop => true, :restart => true
    action [:enable, :start]
  end

  directory instance[:dbpath] do
    owner "mongodb"
    group "mongodb"
    mode "0775"
    recursive true
  end

  directory instance[:logpath] do
    owner "mongodb"
    group "mongodb"
    mode "0775"
    recursive true
  end

  template "/etc/init/mongodb-#{instance[:port]}.conf" do
    source "mongodb.upstart.erb"
    owner "root"
    group "root"
    mode "0644"
    backup false
    variables instance
    notifies :restart, resources(:service => "mongodb-#{instance[:port]}"), :delayed
  end

  template "/etc/mongodb/mongodb.conf" do
    owner "root"
    group "root"
    mode "0644"
    backup false
    variables instance
    notifies :restart, resources(:service => "mongodb-#{instance[:port]}"), :delayed
  end
end
