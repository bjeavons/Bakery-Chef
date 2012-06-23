# Automatically prepare vhosts for drupal sites.
# TODO Make this configurable per host.
require_recipe "hosts"
require_recipe "apache2"

node[:sites].each do |name, attrs|
  site = attrs[:alias]
  # Configure the site vhost
  web_app site do
    template "sites.conf.erb"
    server_name site
    server_aliases [site]
    docroot "#{node[:www_root]}/#{name}/htdocs"
  end
end