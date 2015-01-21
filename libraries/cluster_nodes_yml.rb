require 'chef/node'
require 'yaml'
require 'chef/mixin/shell_out'

class Chef::ResourceDefinitionList::NodesHelper

  def self.read_yml(node)
    yaml_file = node["shared"]["config"]["nodes_file"]
    raw_config = File.read(yaml_file)
    instances = YAML.load(raw_config)
  end

  def self.cluster_members(node)

    begin
       instances = self.read_yml(node)
    rescue
       Chef::Log.warn "Cannot retrieve info from #{node["shared"]["config"]["nodes_file"]}"
       instances = nil
    end

    members = []

    unless instances.nil?
      instances.each do |name, instance|
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
    members.empty? ? cluster_ready = false : cluster_ready = true

    return cluster_ready,members

  end

end
