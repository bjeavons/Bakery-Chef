require_recipe "mysql"
require_recipe "drush"
require_recipe "drush_make"

# Add VM drush command file
cookbook_file "/home/vagrant/.drush/vm.drush.inc" do
  source "vm.drush.inc"
  owner "vagrant"
  group "vagrant"
  mode "0644"
end

# Create sites_destroy script
template "/usr/local/bin/sites_destroy.sh" do
  sites = []
  node[:sites].each do |name, attrs|
    sites << name
  end
  sites = sites.join(' ')
  source "sites_destroy.erb"
  variables(
    :sites => sites
  )
  owner "vagrant"
  group "vagrant"
  mode "0777"
  action :create
end

sql_pass_opt = !node[:mysql][:server_root_password].empty? ? "-p#{node[:mysql][:server_root_password]}" : ""
sql_cmd = "/usr/bin/mysql -u root #{sql_pass_opt}"

node[:sites].each do |name, attrs|
  site_dir = "#{node[:www_root]}/#{name}"
  web_root = "#{site_dir}/htdocs"
  domain = "#{attrs[:alias]}"
  make = "bakery-d#{attrs[:core]}.make"
  master_url = "http://#{attrs[:master]}"
  master_domain = "#{attrs[:master]}"
  slaves = []
  if domain == master_domain
    is_master = true
    attrs[:subs].each do |sub|
      slaves << "'http://#{sub}/'"
    end
  else
    is_master = false
  end
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

  # setup drush alias
  template "/home/vagrant/.drush/#{name}.aliases.drushrc.php" do
    source "drush_alias.erb"
    variables(
      :root => web_root,
      :uri => domain
    )
    owner "vagrant"
    group "vagrant"
    mode "0755"
    action :create
  end

  # setup bakery @todo get vm_bakery feature working
  if is_master
    execute "#{name}-setup-bakery" do
      # This is Bakery master
      command "cd #{web_root}; drush en -y bakery; drush vset -y bakery_is_master 1; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master '#{master_url}/'; drush vset -y bakery_domain '.#{master_domain}';"
    end
    execute "#{name}-setup-bakery-slaves" do
      # This is Bakery master
      slaves = slaves.join(',')
      command "cd #{web_root}; php -r \"print json_encode(array(#{slaves}));\" | drush vset -y --format=json bakery_slaves -; drush cc all;"
    end
  else
    execute "#{name}-setup-bakery" do
      # This is Bakery slave
      command "cd #{web_root}; drush en -y bakery; drush vset -y bakery_is_master 0; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master '#{master_url}/'; drush vset -y bakery_domain '.#{master_domain}'; drush cc all;"
    end
  end

  # setup master for testing
  if is_master
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
