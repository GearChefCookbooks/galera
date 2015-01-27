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

Chef::Log.info "Configuring cluster specified in yml file ..."

#Making a libary call to read yml file and see if there are any members
cluster_ready,cluster_name,members = Chef::ResourceDefinitionList::NodesHelper.cluster_members(node)

my_ip = node['ipaddress']

if cluster_ready
  hosts = []
  members.each do |member|
    ipaddress = member["ipaddress"]
    fqdn = member["fqdn"]
    hostname = member["hostname"]
    port = member["port"]
    hosts << ipaddress
  end

  node.override['wsrep']['cluster_name'] = cluster_name
  node.override['wsrep']['cluster_nodes'] = hosts.join(",")

  template "/etc/mysql/conf.d/galera.cnf" do
    source "galera.erb"
    owner "root"
    group "root"
    mode "755"
  end


  #Primary cluster node is first ip in array
  if my_ip == hosts[0]

      Chef::Log.info "This node ipaddress #{my_ip} is the primary cluster ip."

      bash "initialize_cluster" do
        user "root"
        code <<-EOH
          service mysql stop
          service mysql start --wsrep-new-cluster
        EOH
          #not_if "dpkg -l |grep mysql"
      end

  else

      bash "sync_node" do
        user "root"
        code <<-EOH
          service mysql stop
          service mysql start 
        EOH
          #not_if "dpkg -l |grep mysql"
      end
    
  end
  
else

  Chef::Log.warn "***********************************"
  Chef::Log.warn "There are no nodes found for the cluster ..."
  Chef::Log.warn "File exit status set at 185 ..."
  Chef::Log.warn "***********************************"

  file "/tmp/file_exit_status" do
    content "185"
    owner 'root'
    group 'root'
    mode '444'
  end

  hosts = nil

end

