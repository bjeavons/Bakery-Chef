#
# Chef Solo Config File
#
#repo_root = "#{Dir.tmpdir}/chefsolo"

# log_level          :debug
log_location       STDOUT

base_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
cookbook_path ["#{base_path}/cookbooks", "#{base_path}/site-cookbooks"]

role_path "#{base_path}/roles"
data_bag_path "#{base_path}/data_bags"

Mixlib::Log::Formatter.show_time = false

