
# mcrypt is required for bakery
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

# setup bakery
node[:sites].each do |site|
  site_dir = "#{node[:www_root]}/#{site[:name]}"
  scheme = "http://"
  if !site[:secure].nil? && site[:secure]
    scheme = "https://"
  end
  is_master = false
  slaves = []
  if site[:master] == site[:domain]
    is_master = true
    site[:subs].each do |sub|
      slaves << "'#{scheme}#{sub}/'"
    end
  end
  master_url = "#{scheme}#{site[:master]}"


  # setup bakery @todo get vm_bakery feature working
  if is_master
    # This is Bakery master
    execute "#{site[:name]}-setup-bakery" do
      command "cd #{site_dir}/htdocs; drush en -y bakery; drush vset -y bakery_is_master 1; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master '#{master_url}/'; drush vset -y bakery_domain '.#{site[:domain]}';"
    end
    execute "#{site[:name]}-setup-bakery-slaves" do
      slaves = slaves.join(',')
      command "cd #{site_dir}/htdocs; php -r \"print json_encode(array(#{slaves}));\" | drush vset -y --format=json bakery_slaves -;"
    end
  else
    # This is Bakery slave
    execute "#{site[:name]}-setup-bakery" do
      command "cd #{site_dir}/htdocs; drush en -y bakery; drush vset -y bakery_is_master 0; drush vset -y bakery_key 'bakerysecret'; drush vset -y bakery_master '#{master_url}/'; drush vset -y bakery_domain '.#{site[:master]}';"
    end
  end

  # setup master with test account
  if is_master
    execute "create-#{site[:name]}-test-account" do
      command "cd #{site_dir}/htdocs; drush user-create #{node[:drupal][:test_name]} --mail='#{node[:drupal][:test_name]}@example.com' --password='#{node[:drupal][:test_password]}'"
      ignore_failure true
    end
  end

  # enable registration
  execute "enable-registration" do
    command "cd #{site_dir}/htdocs; drush vset -y user_email_verification 0; drush -y vset user_registration 1"
    ignore_failure true
  end

  execute "clear-cache" do
    command "cd #{site_dir}/htdocs; drush cc all"
    ignore_failure true
  end

end
