Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. For a detailed explanation
  # and listing of configuration options, please view the documentation
  # online.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ms-ubuntu-11.10"

  # Download the box automatically from S3.
  config.vm.box_url = "http://msonnabaum-public.s3.amazonaws.com/ms-ubuntu-11.10.box"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"
    chef.add_role("bakery")
    chef.json.merge!({
    :www_root => '/var/www',
    :sites => {
      "masterd6" => {:alias => "masterd6.vbox", :make => "bakery-d6.make"},
      "subd6" => {:alias => "d6.masterd6.vbox", :make => "bakery-d6.make"},
      "subd7" => {:alias => "d7.masterd6.vbox", :make => "bakery-d7.make"}
    }
  })
  end

  # Run the host with a host-only IP of 172.22.22.22.
  config.vm.network :hostonly, "172.22.22.22"
  config.ssh.max_tries = 1000

  # Forward port 22 to localhost:2222.
  config.vm.forward_port 22, 2222
end
