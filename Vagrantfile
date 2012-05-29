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
    :hosts => {
      :localhost_aliases => {
        "bakerymasterd6" => "masterd6.vbox",
        "bakerysubd6" => "d6.masterd6.vbox",
        "bakerysubd7" => "d7.masterd6.vbox"
      }
    }
  })
  end

  # Run the host with a host-only IP of 172.22.22.22.
  config.vm.network :hostonly, "172.22.22.22"
  config.ssh.max_tries = 1000

  # Forward port 22 to localhost:2222.
  config.vm.forward_port 22, 2222
end
