

# image directory (default) is: /var/lib/glance/images/
# glance mysql user: glance/glance1234


class cc_openstack::roles::controller_node::imageservice {

	Package['glance'] ->
	Package['python-glanceclient'] ->
	File_Line['glance_config_1'] ->
	File_Line['glance_config_2'] ->
	File['/var/lib/glance/glance.sqlite'] ->
	Exec['create_glance_mysql_1'] ->
	Exec['create_glance_mysql_2'] ->
	Exec['create_glance_mysql_3'] ->
	Exec['install_glance_tables'] ->
	Exec['keystone_create_glance_user'] ->
	Exec['keystone_add_glance_role']
	
	
	

	package { 'glance':
		ensure => "installed",
	}
	
	package { 'python-glanceclient':
		ensure => "installed",
	}
	
	#should match the following line: 	=> '#connection = <None>'
	file_line { 'glance_config_1':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^#connection =.*',
		line	=> 'connection = mysql://glance:glance1234@controller/glance',
	}

	#should match the following line: 	=> '#connection = <None>'
	file_line { 'glance_config_2':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^#connection =.*',
		line	=> 'connection = mysql://glance:glance1234@controller/glance',
	}	
	
	file { '/var/lib/glance/glance.sqlite':
		ensure => absent,
	}
	
	
	
	
	
	
	exec { 'create_glance_mysql_1':
		command => 'mysql --user=root --password=tobias1234 --execute=\'CREATE DATABASE glance\'',
		path	=> '/usr/bin/',
	}
	
	
	exec { 'create_glance_mysql_2':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON glance.* TO \'glance\'@\'localhost\' IDENTIFIED BY \'glance1234\'"',
		path	=> '/usr/bin/',
	}
	
	exec { 'create_glance_mysql_3':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON glance.* TO \'glance\'@\'%\' IDENTIFIED BY \'glance1234\'"',
		path	=> '/usr/bin/',
	}
	
	exec { 'install_glance_tables':
		command => 'su -s /bin/sh -c "glance-manage db_sync" glance',
		path	=> '/bin/',
	}
	
	exec { 'keystone_create_glance_user':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-create --name=glance --pass=glance1234 --email=glance@controller',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_add_glance_role':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=glance --tenant=service --role=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	## HIER FERTIG BIS PUNKT 7. "Configure the image service to use the identity service for authentication"
	

}
