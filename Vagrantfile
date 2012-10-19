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
    chef.add_role("db-server")
    chef.add_role("bakery")
    chef.json.merge!({
    :www_root => '/var/www',
    :mysql => {
      "server_root_password" => "1234",
      "drupal_user" => "bakery",
      "drupal_password" => "bakery"
    },
    :drupal => {
      "admin_password" => "1234",
      "test_name" => "test1",
      "test_password" => "1234",
    },
    :sites => {
      "masterd6" => {
        :alias => "masterd6.vbox",
        :core => "6",
        :master => "masterd6.vbox",
        :subs => ["d6.masterd6.vbox", "d7.masterd6.vbox"]
      },
      "d6subd6" => {:alias => "d6.masterd6.vbox", :core => "6", :master => "masterd6.vbox"},
      "d7subd6" => {:alias => "d7.masterd6.vbox", :core => "7", :master => "masterd6.vbox"},
      "masterd7" => {
        :alias => "masterd7.vbox",
        :core => "7",
        :master => "masterd7.vbox",
        :subs => ["d6.masterd7.vbox", "d7.masterd7.vbox"]
      },
      "d6subd7" => {:alias => "d6.masterd7.vbox", :core => "6", :master => "masterd7.vbox"},
      "d7subd7" => {:alias => "d7.masterd7.vbox", :core => "7", :master => "masterd7.vbox"}
    }
  })
  end

  # Run the host with a host-only IP of 172.22.22.22.
  config.vm.network :hostonly, "172.22.22.22"
  config.ssh.max_tries = 1000

  # Forward port 22 to localhost:2222.
  config.vm.forward_port 22, 2222
end
