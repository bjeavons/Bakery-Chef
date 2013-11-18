mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

node[:sites].each do |site|
  # add database
  mysql_database site[:name] do
    action :create
    connection mysql_connection_info
  end

  # grant database user access to db
  mysql_database_user node['db']['user'] do
    connection mysql_connection_info
    password node['db']['password']
    database_name site[:name]
    action :grant
  end
end

# Make ~/.my.cnf file so username and password aren't needed
file "/home/vagrant/.my.cnf" do
  content "[client]\nuser=root\npass=#{node[:mysql][:server_root_password]}"
  action :create
end
