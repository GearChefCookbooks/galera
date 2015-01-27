name             'galera'
maintainer       "Gary Leong"
maintainer_email "gwleong@gmail.com"
license          "Apache 2.0"
description      "Installs Galera MariaDB Cluster for MySQL"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe "server", "Installs Galera MariaDB Cluster for MySQL"

%w{ debian ubuntu centos fedora redhat }.each do |os|
  supports os
end

depends 'apt', '>= 1.8.2'
