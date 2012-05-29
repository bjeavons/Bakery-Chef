#
# Cookbook Name:: percona
# Attribute:: default
#
# Copyright 2012, Myplanet Digital, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Options are: 5.0, 5.1, 5.5, latest
default['percona']['version'] = "5.5"

case node['platform']
when "ubuntu", "debian"
  case node['percona']['version']
  when "5.0"
    normal['mysql']['client']['package_names'] = %w{percona-sql-client}
    normal['mysql']['package_name']  = "percona-sql-server"
  when "5.1"
    normal['mysql']['client']['package_names'] = %w{percona-server-client-5.1}
    normal['mysql']['package_name']  = "percona-server-server-5.1"
  when "5.5"
    normal['mysql']['client']['package_names'] = %w{percona-server-client-5.5}
    normal['mysql']['package_name']  = "percona-server-server-5.5"
  when "latest"
    normal['mysql']['client']['package_names'] = %w{percona-server-client}
    normal['mysql']['package_name']  = "percona-server-server"
  end
end

