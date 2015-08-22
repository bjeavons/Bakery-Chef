# Prepare drush folders
%w{cache/default cache/usage}.each do |dir|
  directory "/home/vagrant/.drush/#{dir}" do
    owner "vagrant"
    group "vagrant"
    mode "0755"
    action :create
    recursive true
  end
end

sql_pass_opt = !node[:mysql][:server_root_password].empty? ? "-p#{node[:mysql][:server_root_password]}" : ""
sql_cmd = "/usr/bin/mysql -u root #{sql_pass_opt}"

# install drupal
node[:sites].each do |site|
  site_dir = "#{node[:www_root]}/#{site[:name]}"
  make = "bakery-d#{site[:core]}.make"

  # Copy makefile
  cookbook_file "copy-#{site[:name]}-makefile" do
    path "#{node[:www_root]}/#{site[:name]}/#{make}"
    source make
    owner node['apache']['user']
    group "vagrant"
    mode 00775
    action :create_if_missing
  end

  # drush make site
  execute "make-#{site[:name]}-site" do
    command "cd #{site_dir}; drush make #{make} htdocs"
    not_if { File.exists?("#{site_dir}/htdocs/index.php") }
  end

  # copy settings.php file
  execute "create-#{site[:name]}-settings-file" do
    command "cp #{site_dir}/htdocs/sites/default/default.settings.php #{site_dir}/htdocs/sites/default/settings.php"
    not_if { File.exists?("#{site_dir}/htdocs/sites/default/settings.php") }
  end

  # chown settings.php file
  execute "chown-#{site[:name]}-settings-file" do
    command "chown #{node['apache']['user']} #{site_dir}/htdocs/sites/default/settings.php"
    not_if { !File.exists?("#{site_dir}/htdocs/sites/default/settings.php") }
  end

  # make files dir
  execute "make-#{site[:name]}-files-dir" do
    command "mkdir #{site_dir}/htdocs/sites/default/files"
    not_if { File.exists?("#{site_dir}/htdocs/sites/default/files") }
  end

  # chown files dir
  execute "chown-#{site[:name]}-files-dir" do
    command "chown #{node['apache']['user']} #{site_dir}/htdocs/sites/default/files"
    not_if { !File.exists?("#{site_dir}/htdocs/sites/default/files") }
  end

  # install site
  db_url = "mysqli://#{node[:db][:user]}:#{node[:db][:password]}@localhost/#{site[:name]}"
  if site[:core] == "7"
    execute "install-#{site[:name]}" do
      command "cd #{site_dir}/htdocs; drush si --db-url=#{db_url} --account-pass=#{node[:drupal][:admin_password]} --site-name='#{site[:name]}' -y"
    end
  else
    # drupal 6 requires specific steps
    cookbook_file "copy-#{site[:name]}-sql" do
      path "/tmp/#{site[:name]}.sql"
      source "#{site[:name]}.sql"
    end
    execute "install-#{site[:name]}" do
      command "#{sql_cmd} #{site[:name]} < /tmp/#{site[:name]}.sql"
    end
    execute "update-admin-user-email" do # fix for issue #4
      command "#{sql_cmd} #{site[:name]} -e 'UPDATE users SET mail = \"admin@example.com\" WHERE uid = 1'"
    end
    execute "install-#{site[:name]}" do
      command "echo \'$db_url = \"#{db_url}\";\' >> #{site_dir}/htdocs/sites/default/settings.php"
    end
  end

  # setup drush alias
  template "/home/vagrant/.drush/#{site[:name]}.aliases.drushrc.php" do
    source "drush_alias.erb"
    variables(
      :root => "#{site_dir}/htdocs",
      :uri => site[:domain]
    )
    owner "vagrant"
    group "vagrant"
    mode "0755"
    action :create
  end

end
