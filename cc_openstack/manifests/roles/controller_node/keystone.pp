


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
	Exec['keystone_restart']
	
	
	package { 'keystone':
		ensure => "installed",
	}

	
	
	#match	=> 'connection = sqlite:////var/lib/keystone/keystone.db',
	
	file_line { 'keystone_config_1':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^connection.*',
		line	=> 'connection = mysql://root:tobias1234@controller/keystone',
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
		match	=> '^#admin_token=.*',
		line	=> 'admin_token=dac71b0650e9aa927577',
	}
	
	file_line { 'keystone_config_3':
		path	=> '/etc/keystone/keystone.conf',
		match	=> '^#log_dir=.*',
		line	=> 'log_dir=/var/log/keystone',
	}
	
	
	exec { 'keystone_restart':
		command => 'service keystone restart',
		path	=> '/usr/sbin/',
	}
	
	



}