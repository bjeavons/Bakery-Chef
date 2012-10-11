package "dnsmasq" do
  action :install
end

service "dnsmasq" do
  action [:enable, :start]
end

# Create dnsmasq bakery domain config
cookbook_file "/etc/dnsmasq.d/dnsmasq_bakery" do
  source "dnsmasq_bakery"
  mode 0755
  owner "root"
  group "root"
  action :create_if_missing
  notifies :restart, resources(:service => "dnsmasq")
end

# Set nameresolving to localhost for vbox domain + google
# public DNS servers
file "/etc/resolv.conf" do
  content "nameserver 127.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4\n"
end
