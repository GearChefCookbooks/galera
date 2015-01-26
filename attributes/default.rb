# Galera
# Cookbook Name:: galera
# Attribute:: default
#
# Copyright 2014, Gary Leong
default['mysql']['tunable']['binlog_format'] = "ROW"
default['mysql']['tunable']['autoinc_lock_mode'] = 2
default['wsrep']['provider'] = "/usr/lib/galera/libgalera_smm.so"
default['wsrep']['cluster_name'] = "my_galera_cluster"
default['wsrep']['cluster_nodes'] = "127.0.0.1"
default['wsrep']['sst_method'] = "rsync"
#May want to add the below at some point
#default['mysql']['root_password'] = "password"
#default['mysql']['port']    = 3306
#default['mysql']['tunable']['buffer_pool_size'] = "256M"
#default['mysql']['tunable']['flush_log_at_trx_commit'] = 2
#default['mysql']['tunable']['file_per_table'] = 1
#default['mysql']['tunable']['doublewrite'] = 0
#default['mysql']['tunable']['log_file_size'] = "512M"
#default['mysql']['tunable']['log_files_in_group'] = 2
#default['mysql']['tunable']['buffer_pool_instances'] = 1
#default['mysql']['tunable']['max_dirty_pages_pct'] = 75
#default['mysql']['tunable']['thread_concurrency'] = 0
#default['mysql']['tunable']['concurrency_tickets'] = 5000
#default['mysql']['tunable']['thread_sleep_delay'] = 10000
#default['mysql']['tunable']['lock_wait_timeout'] = 50
#default['mysql']['tunable']['io_capacity'] = 200
#default['mysql']['tunable']['read_io_threads'] = 4
#default['mysql']['tunable']['write_io_threads'] = 4
#default['mysql']['tunable']['file_format'] = "barracuda"
#default['mysql']['tunable']['flush_method'] = "O_DIRECT"
#default['mysql']['tunable']['locks_unsafe_for_binlog'] = 1
#default['mysql']['tunable']['autoinc_lock_mode'] = 2
#default['mysql']['tunable']['condition_pushdown'] = 1
#default['mysql']['tunable']['binlog_format'] = "ROW"
##OTHER THINGS, BUFFERS ETC
#default['mysql']['tunable']['max_connections'] = 512
#default['mysql']['tunable']['thread_cache_size'] = 512
#default['mysql']['tunable']['table_open_cache'] = 1024
#
#default['wsrep']['port'] = 4567
## How many threads will process writesets from other nodes
## (more than one untested)
#default['wsrep']['slave_threads'] = 1
## Maximum number of rows in write set
#default['wsrep']['max_ws_rows'] = 131072
## Maximum size of write set
#default['wsrep']['max_ws_size'] = 1073741824
## how many times to retry deadlocked autocommits
#default['wsrep']['retry_autocommit'] = 1
## change auto_increment_increment and auto_increment_offset automatically
#default['wsrep']['auto_increment_control'] = 1
## enable "strictly synchronous" semantics for read operations
#default['wsrep']['casual_reads'] = 0
###
### WSREP State Transfer options
###
#default['wsrep']['user'] = "wsrep_sst"
#default['wsrep']['password'] = "wsrep"
#
## State Snapshot Transfer method
#default['wsrep']['sst_method'] = "rsync"
#
## Address on THIS node to receive SST at. DON'T SET IT TO DONOR ADDRESS!!!
## (SST method dependent. Defaults to the first IP of the first interface)
##wsrep_sst_receive_address=<%= node['ipaddress'] %>
#
## SST authentication string. This will be used to send SST to joining nodes.
## Depends on SST method. For mysqldump method it is wsrep_sst:<wsrep password>
#default['wsrep']['sst_auth'] = default['wsrep']['user'] + ":" + default['wsrep']['password']
#
