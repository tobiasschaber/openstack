
#
# install the image service which stores and provides disk images
#
# image directory (default) is: /var/lib/glance/images/
# glance mysql user: glance/glance1234
#
#
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
	File_Line['glance_config_3a'] -> File_Line['glance_config_3b'] -> File_Line['glance_config_3c'] -> File_Line['glance_config_3d'] -> File_Line['glance_config_3e'] -> Exec['glance_config_3f'] ->
	File_Line['glance_config_4a'] -> File_Line['glance_config_4b'] -> File_Line['glance_config_4c'] -> File_Line['glance_config_4d'] -> File_Line['glance_config_4e'] -> Exec['glance_config_4f'] ->
	Exec['keystone_register_image_service'] ->
	Exec['keystone_imageservice_endpoint_create'] ->
	Exec['glance_registry_restart'] ->
	Exec['glance_api_restart'] ->
	Exec['glance-install-cirros-image']


	
	
	

	package { 'glance':
		ensure => "installed",
	}
	
	package { 'python-glanceclient':
		ensure => "installed",
	}
	
	# should match the following line: 	=> '#connection = <None>'
	# set the mysql url for the image service
	file_line { 'glance_config_1':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^#?connection =.*',
		line	=> 'connection = mysql://glance:glance1234@controller/glance',
	}

	
	#should match the following line: 	=> '#connection = <None>'
	# set the mysql url for the image service api
	file_line { 'glance_config_2':
		path	=> '/etc/glance/glance-api.conf',
		match	=> '^#?connection =.*',
		line	=> 'connection = mysql://glance:glance1234@controller/glance',
	}	
	
	file { '/var/lib/glance/glance.sqlite':
		ensure => absent,
	}
	
	
	
	
	
	# create a new mysql database for glance
	exec { 'create_glance_mysql_1':
		command => 'mysql --user=root --password=tobias1234 --execute=\'CREATE DATABASE glance\'',
		path	=> '/usr/bin/',
	}
	
	# create a new mysql user and grant access to the glance tables
	exec { 'create_glance_mysql_2':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON glance.* TO \'glance\'@\'localhost\' IDENTIFIED BY \'glance1234\'"',
		path	=> '/usr/bin/',
	}
	
	# grant additional access
	exec { 'create_glance_mysql_3':
		command => 'mysql --user=root --password=tobias1234 --execute="GRANT ALL PRIVILEGES ON glance.* TO \'glance\'@\'%\' IDENTIFIED BY \'glance1234\'"',
		path	=> '/usr/bin/',
	}
	
	# execute this to instsall the glance database tables needed
	exec { 'install_glance_tables':
		command => 'su -s /bin/sh -c "glance-manage db_sync" glance',
		path	=> '/bin/',
	}
	
	# create a new keystone user for glance
	exec { 'keystone_create_glance_user':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-create --name=glance --pass=glance1234 --email=glance@controller',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# add the new user to a role
	exec { 'keystone_add_glance_role':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone user-role-add --user=glance --tenant=service --role=admin',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
	# adjust the configuration. note that the complete configuration must be done twice in two config files!
	
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
		match	=> '^#?flavor=.*',
		line	=> 'flavor=keystone',
	}
	
	# insert a new line after the first occurence of auth_host = ...
	# this is done to add the new parameter into a special configuration group
	exec { 'glance_config_3f':
		command => 'sed -n \'H;${x;s/^\n//;s/auth_host .*\n/auth_uri = http:\/\/controller:5000\n&/;p;}\' /etc/glance/glance-api.conf > glance-api.conf; mv glance-api.conf /etc/glance/glance-api.conf',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
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
	
	# use keystone for authentication
	file_line { 'glance_config_4e':
		path	=> '/etc/glance/glance-registry.conf',
		match	=> '^#?flavor=.*',
		line	=> 'flavor=keystone',
	}
	
	# insert a new line after the first occurence of auth_host = ...
	exec { 'glance_config_4f':
		command => 'sed -n \'H;${x;s/^\n//;s/auth_host .*\n/auth_uri = http:\/\/controller:5000\n&/;p;}\' /etc/glance/glance-registry.conf > glance-registry.conf; mv glance-registry.conf /etc/glance/glance-registry.conf',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	

	
	
	
	# create a new keystone service for glance
	exec { 'keystone_register_image_service':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'keystone service-create --name=glance --type=image --description=OpenStackImageService',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# create a new endpoint in keystone for glance
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
	
	
	
	# install a basic image (cirros) that will be available from the beginning
	exec { 'glance-install-cirros-image':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'glance image-create --name="cirros-0.3.2-x86_64" --disk-format=qcow2 --container-format=bare --is-public=true --copy-from http://cdn.download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	
}
