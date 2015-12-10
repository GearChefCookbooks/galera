require 'shellwords'

module GaleraCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def password_column_name
      #return 'authentication_string' if v57plus
      return 'password'
    end

    def password_expired
      #return ", password_expired='N'" if v57plus
      return ''
    end

    def root_password
      if new_resource.initial_root_password == ''
        Chef::Log.info('Root password is empty')
        return ''
      end
      Shellwords.escape(new_resource.initial_root_password)
    end

    def mysql_name
      #"mysql-#{new_resource.instance}"
      "mysql-galera"
    end

    def pid_file
      #return new_resource.pid_file if new_resource.pid_file
      #"#{run_dir}/mysqld.pid"
HEREREE      return "#{run_dir}/mysqld.pid"
    end

    def init_records_script
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
  end
end
