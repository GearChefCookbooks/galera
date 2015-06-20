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

e = execute "apt-get update" do
  action :nothing
end


deb http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.32/repo/{os} {dist} main


apt_repository "mariadb" do
  url " http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.32/repo/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "0xcbcb082a1bb943db"
end

if node['platform'] == "ubuntu"
  e.run_action(:run)
end

%w{python-software-properties
mariadb-galera-server-5.5
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

