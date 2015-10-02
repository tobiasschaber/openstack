

# The compute services install the server part of the nova computing system.
# Do not mix up with the main class "roles::compute_node.pp" which will install
# a nova client on a different node. This here is only the server part on the controller!
#
# nova mysql user: nova/nova1234
#
#
class cc_openstack::roles::controller_node::computeservice {

	Package['nova-api'] ->
	Package['nova-cert'] ->
	Package['nova-conductor'] ->
	Package['nova-consoleauth'] ->
	Package['nova-novncproxy'] ->
	Package['nova-scheduler'] ->
	Package['python-novaclient'] ->
	File['/var/lib/nova/nova.sqlite'] ->
	File_Line['nova_config_1a'] -> File_Line['nova_config_1b'] -> File_Line['nova_config_1c'] -> File_Line['nova_config_1d'] -> File_Line['nova_config_1e'] -> File_Line['nova_config_1f'] -> File_Line['nova_config_1g'] -> File_Line['nova_config_1h'] -> File_Line['nova_config_1i'] ->
	File_Line['nova_config_2a'] -> File_Line['nova_config_2b'] ->
	File_Line['nova_config_3a'] -> File_Line['nova_config_3b'] -> File_Line['nova_config_3c'] -> File_Line['nova_config_3d'] -> File_Line['nova_config_3e'] -> File_Line['nova_config_3f'] -> File_Line['nova_config_3g'] -> File_Line['nova_config_3h'] ->
	Exec['create_nova_mysql_1'] ->
	Exec['create_nova_mysql_2'] ->
	Exec['create_nova_mysql_3'] ->
	Exec['install_nova_tables'] ->
	Exec['keystone_create_nova_user'] ->
	Exec['keystone_add_nova_role'] ->
	Exec['keystone_register_compute_service'] -> 
	Exec['keystone_computeservice_endpoint_create'] -> 
	Exec['nova_api_restart'] ->
	Exec['nova_cert_restart'] ->
	Exec['nova_consoleauth_restart'] ->
	Exec['nova_scheduler_restart'] ->
	Exec['nova_conductor_restart'] ->
	Exec['nova_novncproxy_restart']
#	Exec['nova-create-default-network']
	
	
	
	
	package { 'nova-api':
		ensure => "installed";
	}
	
	package { 'nova-cert':
		ensure => "installed";
	}
	
	package { 'nova-conductor':
		ensure => "installed";
	}
	
	package { 'nova-consoleauth':
		ensure => "installed";
	}
	
	package { 'nova-novncproxy':
		ensure => "installed";
	}
	
	package { 'nova-scheduler':
		ensure => "installed";
	}
	
	package { 'python-novaclient':
		ensure => "installed";
	}
	
	file { '/var/lib/nova/nova.sqlite':
		ensure => absent,
	}
	
	
	# the nova configuration has to be adjusted at many points
	#############################################################################################
	
	# set rabbitmq as backend 
	file_line { 'nova_config_1a':
		path	=> '/etc/nova/nova.conf',
		line	=> 'rpc_backend = rabbit',
	}
	
	# set the rabbitmq hostname
	file_line { 'nova_config_1b':
		path	=> '/etc/nova/nova.conf',
		line	=> 'rabbit_host = controller',
	}
	
	# set the rabbitmq password (the user is "guest")
	file_line { 'nova_config_1c':
		path	=> '/etc/nova/nova.conf',
		line	=> 'rabbit_password = tobias1234',
	}
	
	# set the local ip adress
	file_line { 'nova_config_1d':
		path	=> '/etc/nova/nova.conf',
		line	=> "my_ip = ${ipaddress_eth1}",
	}
	
	# set the local ip adress for the vnc server
	file_line { 'nova_config_1e':
		path	=> '/etc/nova/nova.conf',
		line	=> "vncserver_listen = ${ipaddress_eth1}",
	}
	
	# set the local ip adress for the vnc proxy
	file_line { 'nova_config_1f':
		path	=> '/etc/nova/nova.conf',
		line	=> "vncserver_proxyclient_address = ${ipaddress_eth1}",
	}	
	
	# use "keystone" as authentication provider
	file_line { 'nova_config_1g':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_strategy = keystone',
	}	
	
	# set the networking class
	file_line { 'nova_config_1h':
		path	=> '/etc/nova/nova.conf',
		line	=> 'network_api_class = nova.network.api.API',
	}	

	# set the security group
	file_line { 'nova_config_1i':
		path	=> '/etc/nova/nova.conf',
		line	=> 'security_group_api = nova',
	}	
	

	# add a new configuration group "database"
	file_line { 'nova_config_2a':
		path	=> '/etc/nova/nova.conf',
		line	=> '[database]',
	}
	
	# set the mysql url
	file_line { 'nova_config_2b':
		path	=> '/etc/nova/nova.conf',
		line	=> 'connection = mysql://nova:nova1234@controller/nova',
	}
	
	# add a new configuration group "keystone_authtoken"
	file_line { 'nova_config_3a':
		path	=> '/etc/nova/nova.conf',
		line	=> '[keystone_authtoken]',
	}
	
	# set the authentication url to keystone
	file_line { 'nova_config_3b':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_uri = http://controller:5000',
	}

	# set the authentication host name
	file_line { 'nova_config_3c':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_host = controller',
	}
	
	# set the keystone port
	file_line { 'nova_config_3d':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_port = 35357',
	}
	
	# set the authentication protocol
	file_line { 'nova_config_3e':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_protocol = http',
	}
	
	# set the admin tenant from keystone
	file_line { 'nova_config_3f':
		path	=> '/etc/nova/nova.conf',
		line	=> 'admin_tenant_name = service',
	}

	# set the administration user to authenticate
	file_line { 'nova_config_3g':
		path	=> '/etc/nova/nova.conf',
		line	=> 'admin_user = nova',
	}
	
	# set the password for authentication
	file_line { 'nova_config_3h':
		path	=> '/etc/nova/nova.conf',
		line	=> 'admin_password = nova1234',
	}
	
		
	# create a new database for nova
	exec { 'create_nova_mysql_1':
		command => 'mysql --user=root --password=tobias1234 --execute=\'CREATE DATABASE IF NOT EXISTS nova\'',
		path	=> '/usr/bin/',
	}
	
	# add a new mysql user and give access to the new database
	exec { 'create_nova_mysql_2':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON nova.* TO \'nova\'@\'localhost\' IDENTIFIED BY \'nova1234\'"',
		path	=> '/usr/bin/',
	}
	
	# add more privileges for the new user
	exec { 'create_nova_mysql_3':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON nova.* TO \'nova\'@\'%\' IDENTIFIED BY \'nova1234\'"',
		path	=> '/usr/bin/',
	}
	
	# execute this to create the database tables needed for nova
	exec { 'install_nova_tables':
		command => 'su -s /bin/sh -c "nova-manage db sync" nova',
		path	=> '/bin/',
	}
	
	# create a new user in keystone for nova
	exec { 'keystone_create_nova_user':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-create --name=nova --pass=nova1234 --email=nova@controller',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# add the new user to a role
	exec { 'keystone_add_nova_role':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=nova --tenant=service --role=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# create a new service named "nova" in keystone
	exec { 'keystone_register_compute_service':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone service-create --name=nova --type=compute --description=OpenStackComputeService',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# create a new endpoint for nova in keystone
	exec { 'keystone_computeservice_endpoint_create':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone endpoint-create --service-id=$(keystone service-list | awk \'/ compute /    {print $2}\') --publicurl=http://controller:8774/v2/%\(tenant_id\)s --internalurl=http://controller:8774/v2/%\(tenant_id\)s --adminurl=http://controller:8774/v2/%\(tenant_id\)s',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

# TODO RE-ENABLE OR MOVE	
#	# create a basic network for nova
#	exec { 'nova-create-default-network':
#		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
#		command => 'nova network-create demo-net --bridge br100 --multi-host T --fixed-range-v4 203.0.113.24/29',
#		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
#	}
	
	
	
	# restart different services
	########################################################################################
	exec { 'nova_api_restart':
		command => 'service nova-api restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'nova_cert_restart':
		command => 'service nova-cert restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'nova_consoleauth_restart':
		command => 'service nova-consoleauth restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'nova_scheduler_restart':
		command => 'service nova-scheduler restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'nova_conductor_restart':
		command => 'service nova-conductor restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'nova_novncproxy_restart':
		command => 'service nova-novncproxy restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	


}


