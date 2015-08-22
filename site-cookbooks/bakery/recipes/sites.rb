include_recipe "hosts"
include_recipe "apache2"

# domains array used for /etc/hosts
domains = []
node[:sites].each do |site|
  domains << site[:domain]
  # create each site directory
  directory "#{node[:www_root]}/#{site[:name]}" do
    owner node['apache']['user']
    group "vagrant"
    mode 00775
    action :create
    recursive true
  end

  # configure vhosts
  web_app site[:name] do
    server_name site[:domain]
    server_aliases [site[:domain]]
    docroot "#{node[:www_root]}/#{site[:name]}/htdocs"
    if site[:secure]
      template "sites_ssl.conf.erb"
    else
      template "sites.conf.erb"
    end
  end
end

# Create apache key and cert file
cookbook_file "/etc/apache2/apache.pem" do
  source "apache.pem"
  mode 0755
  owner node['apache']['user']
  group node['apache']['group']
  action :create_if_missing
  notifies :restart, "service[apache2]"
end

# Allow sites within the vm to communicate
file '/etc/hosts' do
  content "127.0.0.1 localhost #{domains.join(' ')}

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts"
end
