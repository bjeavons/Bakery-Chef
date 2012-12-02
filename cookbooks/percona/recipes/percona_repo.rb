#
# Cookbook Name:: percona
# Recipe:: percona_repo
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

case node['platform']
when "ubuntu", "debian"
  include_recipe "apt"
  apt_repository "percona" do
    uri "http://repo.percona.com/apt"
    distribution node['lsb']['codename']
    components ['main']
    keyserver "keys.gnupg.net"
    key "CD2EFD2A"
    action :add
  end
when "centos", "rhel", "scientific"
  include_recipe "yum"
  yum_key "RPM-GPG-KEY-percona" do
    url "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
    action :add
  end

  yum_repository "percona" do
    name "CentOS #{node['lsb']['release']} - Percona"
    url "http://repo.percona.com/centos/#{node['lsb']['release']}/os/#{node['kernel']['machine']}/"
    key "RPM-GPG-KEY-percona"
    action :add
  end
end
