#
# Cookbook Name:: galera
# Recipe:: galera_install
#
# Copyright 2014, Gary Leong
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#%w{
#software-properties-common
#}.each do |pkg|
#  package pkg do
#    action :install
#  end
#end
#
#e = execute "apt-get update" do
#  action :nothing
#end
#
#apt_repository "mariadb" do
#  uri " http://mirror.stshosting.co.uk/mariadb/repo/5.5/ubuntu"
#  distribution node['lsb']['codename']
#  components ["main"]
#  keyserver "keyserver.ubuntu.com"
#  key "0xcbcb082a1bb943db"
#end
#
#if node['platform'] == "ubuntu"
#  e.run_action(:run)
#end
#
#%w{mariadb-server
#}.each do |pkg|
#  package pkg do
#    action :install
#    options "--no-install-recommends"
#  end
#end

bash 'install_mariadb' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  apt-get install software-properties-common -y
  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
  add-apt-repository ‘deb http://mirror.stshosting.co.uk/mariadb/repo/5.5/ubuntu #{node["lsb"]["codename"]} main
  apt-get update
  EOH
end

%w{mariadb-server
}.each do |pkg|
  package pkg do
    action :install
    options "--no-install-recommends"
  end
end

template "/etc/mysql/my.cnf" do
  source "my.erb"
  owner "root"
  group "root"
  mode "755"
end

bash "restart_mysql" do
  user "root"
  code <<-EOH
    service mysql restart
  EOH
end

