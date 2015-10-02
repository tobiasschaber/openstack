



# Add the blockstorage (CINDER) to the controller
class cc_openstack::roles::controller_node::blockstorage {

	Package['cinder-api'] ->
	Package['cinder-scheduler'] ->
	File_Line['cinder_config_1'] ->
	File_Line['cinder_config_2'] ->
	File_Line['cinder_config_3'] ->
	File_Line['cinder_config_4'] ->
	File_Line['cinder_config_5'] ->
	File_Line['cinder_config_6'] ->
	File_Line['cinder_config_7'] ->
	File_Line['cinder_config_8'] ->
	File_Line['cinder_config_9'] ->
	File_Line['cinder_config_10'] ->
	File_Line['cinder_config_11'] ->
	File_Line['cinder_config_12'] ->
	File_Line['cinder_config_13'] ->
	File_Line['cinder_config_14'] ->
	File_Line['cinder_config_15'] ->
	Exec['create_cinder_mysql_1'] ->
	Exec['create_cinder_mysql_2'] ->
	Exec['create_cinder_mysql_3'] ->
	Exec['install_cinder_tables'] ->
	Exec['keystone_create_cinder_user'] ->
	Exec['keystone_add_cinder_role'] ->
	Exec['keystone_register_cinder_service'] ->
	Exec['keystone_imageservice_endpoint_create_cinder'] ->
	Exec['keystone_register_cinder_service_v2'] ->
	Exec['keystone_imageservice_endpoint_create_cinder_v2'] ->
	Exec['cinder_scheduler_restart'] ->
	Exec['cinder_api_restart']



	
	
	

	package { 'cinder-api':
		ensure => "installed",
	}
	
	package { 'cinder-scheduler':
		ensure => "installed",
	}

	
	
	file_line { 'cinder_config_1':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rpc_backend = rabbit',
	}
	
	
	file_line { 'cinder_config_2':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_host = controller',
	}
	
	file_line { 'cinder_config_3':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_port = 5672',
	}
	
	file_line { 'cinder_config_4':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_userid = guest',
	}
	
	file_line { 'cinder_config_5':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_password = tobias1234',
	}
	
	file_line { 'cinder_config_6':
		path	=> '/etc/cinder/cinder.conf',
		line	=> '[database]',
	}
	
	file_line { 'cinder_config_7':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'connection = mysql://cinder:cinder1234@controller/cinder',
	}
	
	file_line { 'cinder_config_8':
		path	=> '/etc/cinder/cinder.conf',
		line	=> '[keystone_authtoken]',
	}
	
	file_line { 'cinder_config_9':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_uri = http://controller:5000',
	}
	
	file_line { 'cinder_config_10':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_host = controller',
	}
	
	file_line { 'cinder_config_11':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_port = 35357',
	}
	
	file_line { 'cinder_config_12':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_protocol = http',
	}
	
	file_line { 'cinder_config_13':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_tenant_name = service',
	}
	
	file_line { 'cinder_config_14':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'admin_user = cinder',
	}
	
	file_line { 'cinder_config_15':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'admin_password = cinder1234'
	}
	

	
	# create a new mysql database for cinder
	exec { 'create_cinder_mysql_1':
		command => 'mysql --user=root --password=tobias1234 --execute=\'CREATE DATABASE IF NOT EXISTS cinder\'',
		path	=> '/usr/bin/',
	}
	
	# create a new mysql user and grant access to the cinder tables
	exec { 'create_cinder_mysql_2':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON cinder.* TO \'cinder\'@\'localhost\' IDENTIFIED BY \'cinder1234\'"',
		path	=> '/usr/bin/',
	}
	
	# grant additional access
	exec { 'create_cinder_mysql_3':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON cinder.* TO \'cinder\'@\'%\' IDENTIFIED BY \'cinder1234\'"',
		path	=> '/usr/bin/',
	}
	
	# execute this to install the cinder database tables needed
	exec { 'install_cinder_tables':
		command => 'su -s /bin/sh -c "cinder-manage db_sync" cinder',
		path	=> '/bin/',
	}
	
	
	# create a new keystone user for cinder
	exec { 'keystone_create_cinder_user':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-create --name=cinder --pass=cinder1234 --email=cinder@controller',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# add the new user to a role
	exec { 'keystone_add_cinder_role':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=cinder --tenant=service --role=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	
	# create a new keystone service for glance
	exec { 'keystone_register_cinder_service':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone service-create --name=cinder --type=volume --description=OpenStackBlockStorageService',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# create a new endpoint for nova in keystone
	exec { 'keystone_imageservice_endpoint_create_cinder':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone endpoint-create --service-id=$(keystone service-list | awk \'/ volume /    {print $2}\') --publicurl=http://controller:8776/v1/%\(tenant_id\)s --internalurl=http://controller:8776/v1/%\(tenant_id\)s --adminurl=http://controller:8776/v1/%\(tenant_id\)s',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	# create a new keystone service for glance
	exec { 'keystone_register_cinder_service_v2':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone service-create --name=cinderv2 --type=volumev2 --description=OpenStackBlockStorageServiceV2',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# create a new endpoint for nova in keystone
	exec { 'keystone_imageservice_endpoint_create_cinder_v2':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone endpoint-create --service-id=$(keystone service-list | awk \'/ volumev2 /    {print $2}\') --publicurl=http://controller:8776/v2/%\(tenant_id\)s --internalurl=http://controller:8776/v2/%\(tenant_id\)s --adminurl=http://controller:8776/v2/%\(tenant_id\)s',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# restart different services
	########################################################################################
	exec { 'cinder_scheduler_restart':
		command => 'service cinder-scheduler restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'cinder_api_restart':
		command => 'service cinder-api restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	
	
	
	
}
