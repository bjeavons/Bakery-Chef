require 'rubygems'
require 'rake'
#require 'cucumber'
require 'json'

task :default => :usage

task :usage do
  system("rake -T")
end

#test_dir = File.expand_path('tests')
#Cucumber::Rake::Task.new(:run) do |task|
#  task.cucumber_opts = ["features"]
#end

desc "Setup shared Bakery directories"
task :share do
  if !File.exists?('shared') || !File.exists?('shared/bakery6') || !File.exists?('shared/bakery7')
    raise "Create folder ./shared with subdirectories 'bakery6' and 'bakery7' for Bakery versions 6 and 7 respectively"
  end
  bakery = JSON.parse(File.read("config/node.json"))
  puts "Removing per-site Bakery modules and symlinking to shared"
  bakery['sites'].each do |site|
    vagrant_ssh("sudo rm -rf /var/www/#{site['name']}/htdocs/sites/all/modules/bakery")
    vagrant_ssh("sudo ln -s /var/bakery/bakery#{site['core']} /var/www/#{site['name']}/htdocs/sites/all/modules/bakery")
  end
  puts "Done"
end

def vagrant_command(command)
  system "vagrant #{command}"
end

# Execute shell command on vagrant machine
def vagrant_ssh(command)
  return vagrant_command "ssh -c \"#{command}\""
end
