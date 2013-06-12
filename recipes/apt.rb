apt_repository "10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
  distributions %w[dist]
  components %w[10gen]
  action :add
end

package "mongodb-10gen" do
  version "#{node[:mongodb][:version]}*"
  options '--force-yes -o Dpkg::Options::="--force-confold"'
  only_if "[ $(dpkg -l mongodb-10gen 2>&1 | grep #{node[:mongodb][:version]}.* | grep -c '^h[ic] ') = 0 ]"
end

bash "freeze mongodb-10gen" do
  code "echo mongodb-10gen hold | dpkg --set-selections"
  only_if "[ $(dpkg --get-selections | grep -c 'mongodb-10gen\W*hold') = 0 ]"
end
