
#
# keystone is the central repository storing users, groups, tenants, services and endpoints.
# To use the keystone-client (from command line), follow the following instructions:
#
# create a new file "source-admin" and write the following 4 lines into it:
# export OS_USERNAME=admin
# export OS_PASSWORD=admin1234
# export OS_TENANT_NAME=admin
# export OS_AUTH_URL=http://controller:35357/v2.0
# execute "source source-admin"
# you now should be able to call the "keystone" tool without authentication parameters.
# you also can override the authentication credentials by providing the following env vars:
# export OS_SERVICE_TOKEN=dac71b0650e9aa927577
# export OS_SERVICE_ENDPOINT=http://controller:35357/v2.0
#
# a third solution is to pass the authentication params via the command line. e.g.:
# keystone --os-username=admin --os-password=admin1234 --os-auth-url=http://controller:35357/v2.0 token-get
# keystone --os-username=admin --os-password=admin1234 --os-auth-url=http://controller:35357/v2.0 --os-tenant-name=admin token-get
#
# use this admin token: 		dac71b0650e9aa927577
# mysql credentials: 			admin/tobias1234
# keystone admin credentials: 	admin/admin1234
# keystone demo credentials: 	demo/demo1234

class cc_openstack::roles::controller_node::keystone {

	Package['keystone'] ->
	File_Line['keystone_config_1'] ->
	File['/var/lib/keystone/keystone.db'] ->
	Exec['create_keystone_mysql_1'] ->
	Exec['create_keystone_mysql_2'] ->
	Exec['create_keystone_mysql_3'] ->
	Exec['install_keystone_tables'] ->
	File_Line['keystone_config_2'] ->
	File_Line['keystone_config_3'] ->
	Exec['keystone_restart'] ->
	Exec['keystone_create_admin_user'] ->
	Exec['keystone_create_admin_role'] ->
	Exec['keystone_create_admin_tenant'] ->
	Exec['keystone_link_admin'] ->
	Exec['keystone_link_admin_member'] ->
	Exec['keystone_create_demo_user'] ->
	Exec['keystone_create_demo_tenant'] ->
	Exec['keystone_link_demo_user'] ->
	Exec['keystone_create_service_tenant'] ->
	Exec['keystone_register_service'] ->
	Exec['keystone_create_endpoint']
	
	
	
	package { 'keystone':
		ensure => "installed",
	}
	
	#should match the following line: 	=> 'connection = sqlite:////var/lib/keystone/keystone.db',
	# add the mysql connection url to the config
	file_line { 'keystone_config_1':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^connection.*',
		line	=> 'connection = mysql://keystone:tobias1234@controller/keystone',
	}
	

	# remove the db file to prevent its usage by accident
	file { '/var/lib/keystone/keystone.db':
		ensure => absent,
	}
	
	# create a new mysql database for keystone
	exec { 'create_keystone_mysql_1':
		command => 'mysql --user=root --password=tobias1234 --execute=\'CREATE DATABASE IF NOT EXISTS keystone\'',
		path	=> '/usr/bin/',
	}
	
	# create a keystone mysql user and grant access
	exec { 'create_keystone_mysql_2':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON keystone.* TO \'keystone\'@\'localhost\' IDENTIFIED BY \'tobias1234\'"',
		path	=> '/usr/bin/',
	}
	
	exec { 'create_keystone_mysql_3':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON keystone.* TO \'keystone\'@\'%\' IDENTIFIED BY \'tobias1234\'"',
		path	=> '/usr/bin/',
	}
	
	# execute this to install the mysql tables for keystone
	exec { 'install_keystone_tables':
		command => 'su -s /bin/sh -c "keystone-manage db_sync" keystone',
		path	=> '/bin/',
	}
	
	# add the admin token to the config
	file_line { 'keystone_config_2':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^#?admin_token=.*',
		line	=> 'admin_token=dac71b0650e9aa927577',
	}
	
	# set the log dir in the config
	file_line { 'keystone_config_3':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^#?log_dir=.*',
		line	=> 'log_dir=/var/log/keystone',
	}
	
	
	# restart keystone
	exec { 'keystone_restart':
		command => 'service keystone restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	
	
	
	
	## create admin user, group, tenant, and link them togegher
	
	
	# add a 10 seconds sleep. enough time for the keystone service to be restarted
	exec { 'keystone_create_admin_user':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'sleep 10; keystone user-create --name=admin --email=admin@controller --pass=admin1234',
		onlyif  => 'test ! \"keystone user-list | grep -c admin\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_create_admin_role':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone role-create --name=admin',
		onlyif  => 'test ! \"keystone role-list | grep -c admin\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	exec { 'keystone_create_admin_tenant':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone tenant-create --name=admin --description=AdminTenant',
		onlyif  => 'test ! \"keystone tenant-list | grep -c admin\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}	
	
	exec { 'keystone_link_admin':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=admin --tenant=admin --role=admin',
		onlyif  => 'test ! \"keystone user-role-list --user=admin --tenant=admin | grep -c admin\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}	

	exec { 'keystone_link_admin_member':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=admin --role=_member_ --tenant=admin',
		onlyif  => 'test ! \"keystone user-role-list --user=admin --tenant=admin | grep -c member\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}


	
	## create normal user and link with member group
	
	exec { 'keystone_create_demo_user':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone user-create --name=demo --pass=demo1234 --email=demo@controller',
		onlyif  => 'test ! \"keystone user-list | grep -c demo\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	exec { 'keystone_create_demo_tenant':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone tenant-create --name=demo --description=DemoTenant',
		onlyif  => 'test ! \"keystone tenant-list | grep -c demo\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_link_demo_user':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=demo --role=_member_ --tenant=demo',
		onlyif  => 'test ! \"keystone user-role-list --user=demo --tenant=demo | grep -c member\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_create_service_tenant':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone tenant-create --name=service --description=ServiceTenant',
		onlyif  => 'test ! \"keystone tenant-list | grep -c service\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	exec { 'keystone_register_service':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone service-create --name=keystone --type=identity --description=OpenStackIdentity',
		onlyif  => 'test ! \"keystone service-list | grep -c identity\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_create_endpoint':
		environment => ["OS_SERVICE_TOKEN=dac71b0650e9aa927577", "OS_SERVICE_ENDPOINT=http://controller:35357/v2.0"],
		command => 'keystone endpoint-create --service-id=$(keystone service-list | awk \'/ identity / {print $2}\') --publicurl=http://controller:5000/v2.0 --internalurl=http://controller:5000/v2.0 --adminurl=http://controller:35357/v2.0',
		onlyif  => 'test ! \"keystone endpoint-list | grep -c controller\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}	
	
	
	
	
}



