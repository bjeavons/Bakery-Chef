# Deploy Bakery D7
# TODO Move this to a definition with parameters.
require_recipe "mysql"
require_recipe "drush"
require_recipe "drush_make"

# Add an admin user to mysql
execute "add-admin-user" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "GRANT ALL PRIVILEGES ON *.* TO 'myadmin'@'localhost' IDENTIFIED BY 'myadmin' WITH GRANT OPTION;" +
      "GRANT ALL PRIVILEGES ON *.* TO 'myadmin'@'%' IDENTIFIED BY 'myadmin' WITH GRANT OPTION;\" " +
      "mysql"
  action :run
end

# create a drupal db
execute "add-drupal-db" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE DATABASE bakeryd7;\""
  action :run
  ignore_failure true
end

# Copy make file to site.
bash "install-bakery-d7-makefile" do
  code <<-EOH
(mkdir -p /vagrant/public/bakery-d7.vbox.local)
(cp /vagrant/cookbooks/drupal-cookbooks/drupal/files/bakery-d7/bakery-d7.make /vagrant/public/bakery-d7.vbox.local/bakery-d7.make)
  EOH
  not_if { File.exists?("/vagrant/public/bakery-d7.vbox.local/bakery-d7.make") }
end

# drush make bakery-d7
bash "make-bakery-d7-site" do
  code <<-EOH
(cd /vagrant/public/bakery-d7.vbox.local; drush make bakery-d7.make www)
  EOH
  not_if { File.exists?("/vagrant/public/bakery-d7.vbox.local/www/index.php") }
end

# install site
bash "install-bakery-d7-site" do
  code <<-EOH
(cd /vagrant/public/bakery-d7.vbox.local/www; drush si -y --db-url=mysql://root:root@localhost/bakeryd7 --site-name="Bakery D7" --account-pass="pass")
  EOH
end

# setup site
bash "setup-bakery-d7-site" do
  code <<-EOH
(cd /vagrant/public/bakery-d7.vbox.local/www; drush en -y bakery admin_menu devel)
  EOH
end
#drush vset -y bakery_is_master 1
#drush vest -y bakery_key "bakerysecret"
#drush vset -y bakery_master "http://bakery.dev/"
#drush vset -y bakery_domain ".bakery.dev"
#php -r "print json_encode(array('http://d7.bakery.dev/', 'http://d6.bakery.dev/'));" | drush vset -y --format=json bakery_slaves -
