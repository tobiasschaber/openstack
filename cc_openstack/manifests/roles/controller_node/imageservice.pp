

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
	Exec['keystone_add_glance_role'] ->
	File_Line['glance_config_3a'] -> File_Line['glance_config_3b'] -> File_Line['glance_config_3c'] -> File_Line['glance_config_3d'] -> File_Line['glance_config_3e'] -> File_Line['glance_config_3f'] ->
	File_Line['glance_config_4a'] -> File_Line['glance_config_4b'] -> File_Line['glance_config_4c'] -> File_Line['glance_config_4d'] -> File_Line['glance_config_4e'] -> File_Line['glance_config_4f'] ->
	Exec['keystone_register_image_service'] ->
	Exec['keystone_imageservice_endpoint_create'] ->
	Exec['glance_registry_restart'] ->
	Exec['glance_api_restart']


	
	
	

	package { 'glance':
		ensure => "installed",
	}
	
	package { 'python-glanceclient':
		ensure => "installed",
	}
	
	#should match the following line: 	=> '#connection = <None>'
	file_line { 'glance_config_1':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^#?connection =.*',
		line	=> 'connection = mysql://glance:glance1234@controller/glance',
	}

	#should match the following line: 	=> '#connection = <None>'
	file_line { 'glance_config_2':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^#?connection =.*',
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
	
	
	file_line { 'glance_config_3a':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^auth_host =.*',
		line	=> 'auth_host = controller',
	}
	
	file_line { 'glance_config_3b':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^admin_tenant_name =.*',
		line	=> 'admin_tenant_name = service',
	}
	
	file_line { 'glance_config_3c':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^admin_user =.*',
		line	=> 'admin_user = glance',
	}
	
	file_line { 'glance_config_3d':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^admin_password =.*',
		line	=> 'admin_password = glance1234',
	}
	
	file_line { 'glance_config_3e':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^#?flavor =.*',
		line	=> 'flavor = keystone',
	}
	
	file_line { 'glance_config_3f':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^.keystone_authtoken.*',
		line	=> '[keystone_authtoken]\nauth_uri = http://controller:5000',
	}
	
	
	
	
	file_line { 'glance_config_4a':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^auth_host =.*',
		line	=> 'auth_host = controller',
	}
	
	file_line { 'glance_config_4b':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^admin_tenant_name =.*',
		line	=> 'admin_tenant_name = service',
	}
	
	file_line { 'glance_config_4c':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^admin_user =.*',
		line	=> 'admin_user = glance',
	}
	
	file_line { 'glance_config_4d':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^admin_password =.*',
		line	=> 'admin_password = glance1234',
	}
	
	file_line { 'glance_config_4e':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^#?flavor =.*',
		line	=> 'flavor = keystone',
	}
	
	file_line { 'glance_config_4f':
		path	=> '/etc/glance/glance-registry.conf',
		line	=> 'auth_uri = http://controller:5000',
	}
	
	exec { 'keystone_register_image_service':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone service-create --name=glance --type=image --description=OpenStackImageService',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'keystone_imageservice_endpoint_create':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone endpoint-create --service-id=$(keystone service-list | awk \'/ image /    {print $2}\') --publicurl=http://controller:9292 --internalurl=http://controller:9292 --adminurl=http://controller:9292',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'glance_registry_restart':
		command => 'service glance-registry restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
			
	exec { 'glance_api_restart':
		command => 'service glance-api restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	# Dann noch die beiden auth_uri und flavor an die original stellen verschieben !!!!!
	
	
	
	## HIER FERTIG BIS PUNKT 7. "Configure the image service to use the identity service for authentication"
	
	
}
