#
# Cookbook Name:: galera
# Recipe:: galera_install
#
# Copyright 2015, Gary Leong
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

#galera-3_25.3.9-precise_amd64.deb                     mariadb-client_5.5.42+maria-1~trusty_all.deb             mariadb-common_5.5.42+maria-1~trusty_all.deb
#libmariadbclient18_5.5.42+maria-1~trusty_amd64.deb    mariadb-client-5.5_5.5.42+maria-1~trusty_amd64.deb       mariadb-galera-server-5.5_5.5.42+maria-1~trusty_amd64.deb
#libmariadbclient-dev_5.5.42+maria-1~trusty_amd64.deb  mariadb-client-core-5.5_5.5.42+maria-1~trusty_amd64.deb
#http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu/pool/main/m/mariadb-5.5/


e = execute "apt-get update" do
  action :nothing
end

%w{python-software-properties
software-properties-common
mysql-common
libreadline5
libdbi-perl
libdbd-mysql-perl
libaio1
iproute
}.each do |pkg|
  package pkg do
    action :install
    options "--no-install-recommends"
  end
end

%w{
mariadb-common_5.5.42+maria-1~trusty_all.deb
libmariadbclient18_5.5.42+maria-1~trusty_amd64.deb
libmysqlclient18_5.5.42+maria-1~trusty_amd64.deb
mariadb-client-core-5.5_5.5.42+maria-1~trusty_amd64.deb
mariadb-client_5.5.42+maria-1~trusty_all.deb
mariadb-client-5.5_5.5.42+maria-1~trusty_amd64.deb
mariadb-galera-server-5.5_5.5.42+maria-1~trusty_amd64.deb
}.each do |pkg|
  remote_file "/tmp/#{pkg}" do
    source "http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu/pool/main/m/mariadb-5.5/#{pkg}"
    mode '0644'
  end
end

%w{galera-3_25.3.9-trusty_amd64.deb
}.each do |pkg|
  remote_file "/tmp/#{pkg}" do
    source "http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu/pool/main/g/galera-3/#{pkg}"
    mode '0644'
  end
end


#mariadb-common                    5.5.42+maria-1~trusty         all          MariaDB database common files (e.g. /etc/mysql/conf.d/mariadb.cnf)
#libmariadbclient18                5.5.42+maria-1~trusty         amd64        MariaDB database client library
#libmysqlclient18                  5.5.42+maria-1~trusty         amd64        Virtual package to satisfy external depends
#mariadb-client-5.5                5.5.42+maria-1~trusty         amd64        MariaDB database client binaries
#mariadb-client-core-5.5           5.5.42+maria-1~trusty         amd64        MariaDB database core client binaries
#mariadb-galera-server-5.5         5.5.42+maria-1~trusty         amd64        MariaDB database server with Galera cluster binaries




#apt_repository "mariadb" do
#  url "http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu/"
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
#%w{mariadb-galera-server-5.5
#}.each do |pkg|
#  package pkg do
#    action :install
#    options "--no-install-recommends"
#  end
#end




#template "/etc/mysql/my.cnf" do
#  source "my.erb"
#  owner "root"
#  group "root"
#  mode "755"
#end
#
#bash "restart_mysql" do
#  user "root"
#  code <<-EOH
#    service mysql restart
#  EOH
#end
#

