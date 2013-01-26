# Automatically prepare vhosts for drupal sites.
require_recipe "hosts"
require_recipe "apache2"

sites = []
node[:sites].each do |name, attrs|
  site = attrs[:alias]
  sites << site
  # Configure the site vhost
  web_app site do
    if attrs[:secure]
      template "sites_ssl.conf.erb"
    else
      template "sites.conf.erb"
    end
    server_name site
    server_aliases [site]
    docroot "#{node[:www_root]}/#{name}/htdocs"
  end
end

# Allow sites within the vm to communicate
file '/etc/hosts' do
  content "127.0.0.1 localhost ms-ubuntu-11 #{sites.join(' ')}

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts"
end

# Create apache key and cert file
cookbook_file "/etc/apache2/apache.pem" do
  source "apache.pem"
  mode 0755
  owner "root"
  group "root"
  action :create_if_missing
end
