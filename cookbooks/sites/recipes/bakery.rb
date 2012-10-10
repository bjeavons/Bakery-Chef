require_recipe "mysql"
require_recipe "drush"
require_recipe "drush_make"

node[:sites].each do |name, attrs|
  site_dir = "#{node[:www_root]}/#{name}"
  web_root = "#{site_dir}/htdocs"
  make = "bakery-d#{attrs[:core]}.make"
  db_url = "mysql://#{node[:mysql][:drupal_user]}:#{node[:mysql][:drupal_password]}@localhost/#{name}"
  cookie_domain = ".#{attrs[:master]}"

  # Create DB
  execute "add-#{name}-db" do
    command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} -e \"" +
        "CREATE DATABASE #{name};" +
        "GRANT ALL PRIVILEGES ON #{name}.* TO '#{node[:mysql][:drupal_user]}'@'localhost' IDENTIFIED BY '#{node[:mysql][:drupal_password]}';\""
    action :run
    ignore_failure true
  end

  # Create site dir
  execute "create-#{name}-site-dir" do
    command "mkdir -p #{site_dir}"
    not_if { File.exists?("#{site_dir}/#{make}") }
  end

  # Copy makefile
  execute "copy-#{name}-makefile" do
    command "cp /vagrant/cookbooks/sites/files/#{make} #{site_dir}/#{make}"
    not_if { File.exists?("#{site_dir}/#{make}") }
  end

  # drush make site
  execute "make-#{name}-site" do
    command "cd #{site_dir}; drush make #{make} htdocs"
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
    not_if { !File.exists?("#{web_root}/sites/default/settings.php") }
  end

  # make files dir
  execute "make-#{name}-files-dir" do
    command "mkdir #{web_root}/sites/default/files"
    not_if { File.exists?("#{web_root}/sites/default/files") }
  end

  # chown files dir
  execute "chown-#{name}-files-dir" do
    command "chown www-data #{web_root}/sites/default/files"
    not_if { !File.exists?("#{web_root}/sites/default/files") }
  end

  # install site
  execute "install-#{name}" do
    # @todo get drush si working with Drupal 6
    if attrs[:core] == "7"
      command "cd #{web_root}; drush si --db-url=#{db_url} --account-pass=#{node[:drupal][:admin_password]} --site-name='#{name}' -y"
    else
      command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} #{name} < /vagrant/cookbooks/sites/files/#{name}.sql; echo \'$db_url = \"#{db_url}\";\' >> #{web_root}/sites/default/settings.php"
    end
  end

  # setup bakery
  execute "#{name}-setup-bakery" do
    if attrs[:master] == attrs[:alias]
      # This is Bakery master
      subs = []
      attrs[:subs].each do |sub|
        subs << "'http://#{sub}/'"
      end
      subs = subs.join(',')
      command "cd #{web_root}; drush en -y bakery; drush vset -y bakery_is_master 1; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master 'http://#{attrs[:master]}/'; drush vset -y bakery_domain '#{cookie_domain}'; php -r \"print json_encode(array(#{subs}));\" | drush vset -y --format=json bakery_slaves -;"
    else
      # This is Bakery slave
      command "cd #{web_root}; drush en -y bakery; drush vset -y bakery_is_master 0; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master 'http://#{attrs[:master]}/'; drush vset -y bakery_domain '#{cookie_domain}';"
    end
  end
end