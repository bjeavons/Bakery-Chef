include_recipe "apt"

php_pear "pear" do
  action :upgrade
end

package "mcrypt" do
  action :install
end

package "php5-mcrypt" do
  action :install
end

cookbook_file "/usr/lib/php5/mcrypt.so" do
  source "mcrypt/mcrypt.so"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/php5/conf.d/mcrypt.ini" do
  source "mcrypt/mcrypt.ini"
  owner "root"
  group "root"
  mode "0644"
end