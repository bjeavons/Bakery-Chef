require 'rubygems'
require 'rake'
#require 'cucumber'
require 'vagrant'
require 'json'

task :default => :usage
 
task :usage do
  system("rake -T")
end

desc "Run vagrant up"
task :up do
  vm = get_vm
  vm.up unless vm.state == :running
  puts "VM is running"
end

desc "Run vagrant provision"
task :provision do
  vm = get_vm
  raise "Vagrant machine is not running" unless vm.state == :running
  vm.provision
end

desc "Reset to before Bakery cluster installations"
task :reset do
  vm = get_vm
  raise "Vagrant machine is not running" unless vm.state == :running
  vm.channel.execute "sites_destroy.sh"
  puts "Bakery sites destroyed"
end

desc "Setup shared Bakery directories"
task :share do
  vm = get_vm
  raise "Vagrant machine is not running" unless vm.state == :running
  if !File.exists?('shared') || !File.exists?('shared/bakery6') || !File.exists?('shared/bakery7')
    raise "Create folder ./shared with subdirectories 'bakery6' and 'bakery7' for Bakery versions 6 and 7 respectively"
  end
  bakery = JSON.parse(File.read("config/node.json"))
  puts "Removing per-site Bakery modules and symlinking to shared"
  bakery['sites'].each do |name, attrs|
    vm.channel.sudo("rm -rf /var/www/#{name}/htdocs/sites/all/modules/bakery")
    vm.channel.sudo("ln -s /var/bakery/bakery#{attrs['core']} /var/www/#{name}/htdocs/sites/all/modules/bakery")
  end
  puts "Done"
end

#test_dir = File.expand_path('tests')
#Cucumber::Rake::Task.new(:run) do |task|
#  task.cucumber_opts = ["features"]
#end

##
# Get vm machine object
#
def get_vm
  Vagrant::Environment.new(:ui_class => Vagrant::UI::Colored).vms[:default]
end
