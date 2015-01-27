require 'chef/node'
require 'yaml'
require 'chef/mixin/shell_out'

class Chef::ResourceDefinitionList::NodesHelper

  def self.read_yml(node)
    yaml_file = node["shared"]["config"]["nodes_file"]
    raw_config = File.read(yaml_file)
    instances = YAML.load(raw_config)
    return instances
  end

  def self.cluster_members(node)

    cluster_name = nil

    begin
       instances = self.read_yml(node)
    rescue
       Chef::Log.warn "Cannot retrieve info from #{node["shared"]["config"]["nodes_file"]}"
       instances = nil
    end

    members = []

    unless instances.nil?
      instances.each do |name, instance|
        new_cluster_name = instance["cluster"]+"_"+instance["instance"]
        if cluster_name.nil?
          cluster_name = new_cluster_name
        else
          if cluster_name != new_cluster_name
            Chef::Log.error "This name has a different cluster name than the prior node"
          end
        end

        member = Chef::Node.new
        member.name(name)
        member.default['fqdn'] = instance["ipaddresses"]["private"]
        member.default['ipaddress'] = instance["ipaddresses"]["private"]
        member.default['hostname'] = name
        member.default['port'] = node['mysql']['port']
        members << member
      end
    end

    #We want at least 1 node to create a cluster or a basis for a cluster
    if members.empty?
       cluster_ready = false
       cluster_name = false
    else
       cluster_ready = true
    end

    return cluster_ready,cluster_name,members

  end

end
