# Automatically prepare vhosts for drupal sites.
require_recipe "hosts"
require_recipe "apache2"

sites = []
node[:sites].each do |name, attrs|
  site = attrs[:alias]
  sites << site
  # Configure the site vhost
  web_app site do
    template "sites.conf.erb"
    server_name site
    server_aliases [site]
    docroot "#{node[:www_root]}/#{name}/htdocs"
  end
end

file '/etc/hosts' do
  content "127.0.0.1 localhost #{sites.join(' ')}

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts"
end