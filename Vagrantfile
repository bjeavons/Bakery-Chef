Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Uncomment the following lines to enable NFS sharing of the Bakery module from
  # the host. After running `vagrant up` or `vagrant provision` run `rake share`
  # to set the Drupal sites to using the shared Bakery modules.
  #config.vm.synced_folder Pathname.new("shared/bakery6").realpath.to_s, "/var/bakery/bakery6", :create => true, :nfs => true
  #config.vm.synced_folder Pathname.new("shared/bakery7").realpath.to_s, "/var/bakery/bakery7/", :create => true, :nfs => true

  config.vm.provision :chef_solo do |chef|
    bakery = JSON.parse(File.read("config/node.json"))
    chef.cookbooks_path = ["cookbooks"]
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"
    chef.add_recipe("apt")
    chef.add_role("db-server")
    chef.add_role("bakery")
    chef.json.merge!(bakery)
  end

  # Run the host with a host-only IP of 172.22.22.22.
  config.vm.network :private_network, ip: "172.22.22.22"
end
