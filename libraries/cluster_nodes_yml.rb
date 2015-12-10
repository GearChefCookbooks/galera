require 'chef/node'
require 'yaml'
require 'chef/mixin/shell_out'
require 'shellwords'

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

  def self.init_records_script(node)

    mysql_name = "mysql_galera"
    pid_file = "/var/run/mysqld/mysqld.pid"
    root_password = node["galera"]["password"]
    password_expired = ''
    password_column_name = ''
    #Shellwords.escape(root_password)

    return false if root_password == ''

    <<-EOS
      set -e
      rm -rf /tmp/#{mysql_name}
      mkdir /tmp/#{mysql_name}

      cat > /tmp/#{mysql_name}/my.sql <<-EOSQL
UPDATE mysql.user SET #{password_column_name}=PASSWORD('#{root_password}')#{password_expired} WHERE user = 'root';
DELETE FROM mysql.user WHERE USER LIKE '';
DELETE FROM mysql.user WHERE user = 'root' and host NOT IN ('127.0.0.1', 'localhost');
FLUSH PRIVILEGES;
DELETE FROM mysql.db WHERE db LIKE 'test%';
DROP DATABASE IF EXISTS test ;
EOSQL

     while [ ! -f #{pid_file} ] ; do sleep 1 ; done
     kill `cat #{pid_file}`
     while [ -f #{pid_file} ] ; do sleep 1 ; done
     rm -rf /tmp/#{mysql_name}
     EOS
  end

  def self.set_password(node)
      bash "setting root password: mysql galera" do
        code self.init_records_script(node)
        action :run
      end
  end

end

########################################
#/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock --port=3306 --wsrep_start_position=00000000-0000-0000-0000-000000000000:-1

