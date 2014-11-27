


# use this admin token: dac71b0650e9aa927577
# mysql credentials: admin/tobias1234
# keystone admin credentials: admin/admin1234
# keystone demo credentials: demo/demo1234

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
	Exec['keystone_create_service_tenant']
	
	
	package { 'keystone':
		ensure => "installed",
	}
	
	#should match the following line: 	=> 'connection = sqlite:////var/lib/keystone/keystone.db',
	file_line { 'keystone_config_1':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^connection.*',
		line	=> 'connection = mysql://keystone:tobias1234@controller/keystone',
	}
	

	
	file { '/var/lib/keystone/keystone.db':
		ensure => absent,
	}
	
	exec { 'create_keystone_mysql_1':
		command => 'mysql --user=root --password=tobias1234 --execute=\'CREATE DATABASE keystone\'',
		path	=> '/usr/bin/',
	}
	
	exec { 'create_keystone_mysql_2':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON keystone.* TO \'keystone\'@\'localhost\' IDENTIFIED BY \'tobias1234\'"',
		path	=> '/usr/bin/',
	}
	
	exec { 'create_keystone_mysql_3':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON keystone.* TO \'keystone\'@\'%\' IDENTIFIED BY \'tobias1234\'"',
		path	=> '/usr/bin/',
	}
	
	exec { 'install_keystone_tables':
		command => 'su -s /bin/sh -c "keystone-manage db_sync" keystone',
		path	=> '/bin/',
	}
	
	file_line { 'keystone_config_2':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^#?admin_token=.*',
		line	=> 'admin_token=dac71b0650e9aa927577',
	}
	
	file_line { 'keystone_config_3':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^#?log_dir=.*',
		line	=> 'log_dir=/var/log/keystone',
	}
	
	
	exec { 'keystone_restart':
		command => 'service keystone restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	
	
	## create admin user, group, tenant, and link them togegher
	
	exec { 'keystone_create_admin_user':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 user-create --name=admin --email=admin@controller --pass=admin1234',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_create_admin_role':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 role-create --name=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	exec { 'keystone_create_admin_tenant':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 tenant-create --name=admin --description=AdminTenant',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}	
	
	exec { 'keystone_link_admin':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 user-role-add --user=admin --tenant=admin --role=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}	

	exec { 'keystone_link_admin_member':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 user-role-add --user=admin --role=_member_ --tenant=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}		


	
	## create normal user and link with member group
	
	exec { 'keystone_create_demo_user':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 user-create --name=demo --pass=demo1234 --email=demo@controller',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	exec { 'keystone_create_demo_tenant':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 tenant-create --name=demo --description=DemoTenant',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_link_demo_user':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 user-role-add --user=demo --role=_member_ --tenant=demo',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	
	exec { 'keystone_create_service_tenant':
		command => 'keystone --os-token=dac71b0650e9aa927577 --os-auth-url=http://controller:35357/v2.0 --os-endpoint=http://controller:35357/v2.0 tenant-create --name=service --description=ServiceTenant',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

}