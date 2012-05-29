require_recipe "mysql"
require_recipe "drush"
require_recipe "drush_make"

# Create Bakery master Drupal DB
execute "add-master-db" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE DATABASE bakerymaster;\""
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE DATABASE bakerysubd6;\""
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
      "CREATE DATABASE bakerysubd7;\""
  action :run
  ignore_failure true
end

# Setup Bakery master webroot
bash "setup-bakery-master-webroot" do
  code <<-EOH
(mkdir -p /var/www/bakerymasterd6)
  EOH
  not_if { File.exists?("/var/www/bakerymasterd6/bakery-d6.make") }
end

# Copy make file to webroot
bash "setup-bakery-master-webroot" do
  code <<-EOH
(cp /vagrant/cookbooks/sites/files/bakery-d6.make /var/www/bakerymasterd6/bakery-d6.make)
  EOH
  not_if { File.exists?("/var/www/bakerymasterd6/bakery-d6.make") }
end

# Drush make Bakery master
bash "make-bakery-master-site" do
  code <<-EOH
(cd /var/www/bakerymasterd6/; drush make bakery-d6.make htdocs)
  EOH
  not_if { File.exists?("/var/www/bakerymasterd6/htdocs/index.php") }
end

# 
bash "create-bakery-master-settings" do
  code <<-EOH
(cp /var/www/bakerymasterd6/htdocs/sites/default/default.settings.php /var/www/bakerymasterd6/htdocs/sites/default/settings.php)
(mkdir /var/www/bakerymasterd6/htdocs/sites/default/files)
(chown www-data /var/www/bakerymasterd6/htdocs/sites/default/settings.php)
(chown www-data /var/www/bakerymasterd6/htdocs/sites/default/files)
(chmod u+w /var/www/bakerymasterd6/htdocs/sites/default/settings.php)
(chmod u+w /var/www/bakerymasterd6/htdocs/sites/default/files)
  EOH
  not_if { File.exists?("/var/www/bakerymasterd6/htdocs/sites/default/settings.php") }
end

# Setup Bakery subsite webroot
bash "setup-bakery-subsite-webroot" do
  code <<-EOH
(mkdir -p /var/www/bakerysubd6)
  EOH
  not_if { File.exists?("/var/www/bakerysubd6/htdocs/index.php") }
end

# Copy Bakery master to sub-site
bash "copy-bakery-master-sub" do
  code <<-EOH
(cp -R /var/www/bakerymaster/htdocs /var/www/bakerysubd6/htdocs)
  EOH
  not_if { File.exists?("/var/www/bakerymasterd6/htdocs/index.php") }
end

# Setup Bakery sub D7 webroot
bash "setup-bakery-subd7-webroot" do
  code <<-EOH
(mkdir -p /var/www/bakerysubd7)
  EOH
  not_if { File.exists?("/var/www/bakerysubd7/bakery-d7.make") }
end

# Copy make file to webroot
bash "setup-bakery-subd7-webroot" do
  code <<-EOH
(cp /vagrant/cookbooks/sites/files/bakery-d7.make /var/www/bakerysubd7/bakery-d7.make)
  EOH
  not_if { File.exists?("/var/www/bakerysubd7/bakery-d7.make") }
end

# Drush make Bakery master
bash "make-bakery-subd7-site" do
  code <<-EOH
(cd /var/www/bakerysubd7/; drush make bakery-d7.make htdocs)
  EOH
  not_if { File.exists?("/var/www/bakerysubd7/htdocs/index.php") }
end

# 
bash "create-bakery-subd7-settings" do
  code <<-EOH
(cp /var/www/bakerysubd7/htdocs/sites/default/default.settings.php /var/www/bakerysubd7/htdocs/sites/default/settings.php)
(mkdir /var/www/bakerysubd7/htdocs/sites/default/files)
(chown www-data /var/www/bakerysubd7/htdocs/sites/default/settings.php)
(chown www-data /var/www/bakerysubd7/htdocs/sites/default/files)
(chmod u+w /var/www/bakerysubd7/htdocs/sites/default/settings.php)
(chmod u+w /var/www/bakerysubd7/htdocs/sites/default/files)
  EOH
  not_if { File.exists?("/var/www/bakerysubd7/htdocs/sites/default/settings.php") }
end