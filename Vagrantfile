Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. For a detailed explanation
  # and listing of configuration options, please view the documentation
  # online.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ms-ubuntu-11.10"

  # Download the box automatically from S3.
  config.vm.box_url = "http://msonnabaum-public.s3.amazonaws.com/ms-ubuntu-11.10.box"

  # Uncomment the following lines to enable NFS sharing of the Bakery module from
  # the host. After running `vagrant up` or `vagrant provision` run `rake share`
  # to set the Drupal sites to using the shared Bakery modules.
  #config.vm.share_folder 'bakery6', '/var/bakery/bakery6', Pathname.new("shared/bakery6").realpath.to_s, :create => true, :nfs => true
  #config.vm.share_folder 'bakery7', '/var/bakery/bakery7', Pathname.new("shared/bakery7").realpath.to_s, :create => true, :nfs => true
  config.vm.provision :shell, :inline => 'apt-get update'
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
  config.vm.network :hostonly, "172.22.22.22"
  config.ssh.max_tries = 1000

  # Forward port 22 to localhost:2222.
  config.vm.forward_port 22, 2222
end
