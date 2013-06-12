directory "/etc/mongodb" do
  owner "mongodb"
  group "mongodb"
  mode "0775"
  recursive true
end

node[:mongodb][:instances].each do |instance|

  template "/etc/init/mongodb_#{instance[:port]}.conf" do
    source "mongodb.upstart.erb"
    owner "root"
    group "root"
    mode "0644"
    backup false
    variables instance
    # notifies :restart, resources(:service => "mongodb_#{instance[:port]}"), :delayed
  end

  service "mongodb_#{instance[:port]}" do
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

  template "/etc/mongodb/mongodb_#{instance[:port]}.conf" do
    source "mongodb.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    backup false
    variables instance
    notifies :restart, resources(:service => "mongodb_#{instance[:port]}"), :delayed
  end
end
