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

apt_repository "mariadb" do
  uri " http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu"
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

#Chef::Log.info "Configuring cluster specified in yml file ..."
#
##Making a libary call to read yml file and see if there are any members
#cluster_ready,cluster_name,members = Chef::ResourceDefinitionList::NodesHelper.cluster_members(node)
#
#my_ip = node['ipaddress']
#
#if cluster_ready
#  hosts = []
#  members.each do |member|
#    ipaddress = member["ipaddress"]
#    fqdn = member["fqdn"]
#    hostname = member["hostname"]
#    port = member["port"]
#    hosts << ipaddress
#  end
#
#  node.override['wsrep']['cluster_name'] = cluster_name
#  #For the init host, we take the first node of the array
#  init_host = hosts[0]
#  sync_host = init_host
#
#else
#
#  Chef::Log.warn "***********************************"
#  Chef::Log.warn "There are no nodes found for the cluster ..."
#  #Chef::Log.warn "File exit status set at 185 ..."
#  Chef::Log.warn "***********************************"
#
#  #file "/tmp/file_exit_status" do
#  #  content "185"
#  #  owner 'root'
#  #  group 'root'
#  #  mode '444'
#
#  #end
#
#  hosts = nil
#
#end

