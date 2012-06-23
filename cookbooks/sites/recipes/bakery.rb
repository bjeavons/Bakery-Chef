require_recipe "mysql"
require_recipe "drush"
require_recipe "drush_make"

node[:sites].each do |name, attrs|
  site_dir = "#{node[:www_root]}/#{name}"
  web_root = "#{site_dir}/htdocs"

  # Create DB
  execute "add-#{name}-db" do
    command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
        "CREATE DATABASE #{name};\""
    action :run
    ignore_failure true
  end

  # Create site dir
  execute "create-#{name}-site-dir" do
    command "mkdir -p #{site_dir}"
    not_if { File.exists?("#{site_dir}/#{attrs[:make]}") }
  end

  # Copy makefile
  execute "copy-#{name}-makefile" do
    command "cp /vagrant/cookbooks/sites/files/#{attrs[:make]} #{site_dir}/#{attrs[:make]}"
    not_if { File.exists?("#{site_dir}/#{attrs[:make]}") }
  end

  # drush make site
  execute "make-#{name}-site" do
    command "cd #{site_dir}; drush make #{attrs[:make]} htdocs"
    not_if { File.exists?("#{web_root}/index.php") }
  end

  # copy settings.php file
  execute "create-#{name}-settings-file" do
    command "cp #{web_root}/sites/default/default.settings.php #{web_root}/sites/default/settings.php"
    not_if { File.exists?("#{web_root}/sites/default/settings.php") }
  end

  # chown settings.php file
  execute "chown-#{name}-settings-file" do
    command "chown www-data #{web_root}/sites/default/settings.php"
    not_if { File.exists?("#{web_root}/sites/default/settings.php") }
  end

  # make files dir
  execute "make-#{name}-files-dir" do
    command "mkdir #{web_root}/sites/default/files"
    not_if { File.exists?("#{web_root}/sites/default/files") }
  end

  # chown files dir
  execute "chown-#{name}-files-dir" do
    command "chown www-data #{web_root}/sites/default/files"
    not_if { File.exists?("#{web_root}/sites/default/files") }
  end
end