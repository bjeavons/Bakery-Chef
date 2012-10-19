require_recipe "mysql"
require_recipe "drush"
require_recipe "drush_make"

sql_pass_opt = !node[:mysql][:server_root_password].empty? ? "-p #{node[:mysql][:server_root_password]}" : ""
sql_cmd = "/usr/bin/mysql -u root #{sql_pass_opt}"

node[:sites].each do |name, attrs|
  site_dir = "#{node[:www_root]}/#{name}"
  web_root = "#{site_dir}/htdocs"
  make = "bakery-d#{attrs[:core]}.make"
  db_url = "mysqli://#{node[:mysql][:drupal_user]}:#{node[:mysql][:drupal_password]}@localhost/#{name}"
  cookie_domain = ".#{attrs[:master]}"

  # Create DB TODO Use Provider
  execute "add-#{name}-db" do
    command "#{sql_cmd} -e \"" +
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
  cookbook_file "copy-#{name}-makefile" do
    path "#{site_dir}/#{make}"
    source make
    action :create_if_missing
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
  if attrs[:core] == "7"
    execute "install-#{name}" do
      command "cd #{web_root}; drush si --db-url=#{db_url} --account-pass=#{node[:drupal][:admin_password]} --site-name='#{name}' -y"
    end
  else
    # Copy makefile
    cookbook_file "copy-#{name}-sql" do
      path "/tmp/#{name}.sql"
      source "#{name}.sql"
    end
    execute "install-#{name}" do
      command "#{sql_cmd} #{name} < /tmp/#{name}.sql"
    end
    execute "install-#{name}" do
      command "echo \'$db_url = \"#{db_url}\";\' >> #{web_root}/sites/default/settings.php"
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
      command "cd #{web_root}; drush en -y bakery; drush vset -y bakery_is_master 1; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master 'http://#{attrs[:master]}/'; drush vset -y bakery_domain '#{cookie_domain}'; php -r \"print json_encode(array(#{subs}));\" | drush vset -y --format=json bakery_slaves -; drush cc all;"
    else
      # This is Bakery slave
      command "cd #{web_root}; drush en -y bakery; drush vset -y bakery_is_master 0; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master 'http://#{attrs[:master]}/'; drush vset -y bakery_domain '#{cookie_domain}'; drush cc all;"
    end
  end

  # create test1 accounts on master
  if attrs[:master] == attrs[:alias]
    execute "create-#{name}-test-account" do
      command "cd #{web_root}; drush user-create #{node[:drupal][:test_name]} --mail='#{node[:drupal][:test_name]}@example.com' --password='#{node[:drupal][:test_password]}'"
      ignore_failure true
    end
  end

  # setup /etc/hosts @todo this isn't working https://github.com/bjeavons/Bakery-Chef/issues/2
  #execute "#{name}-setup-hosts" do
  #  command "echo '127.0.0.1 #{name}' >> /etc/hosts"
  #end
end
