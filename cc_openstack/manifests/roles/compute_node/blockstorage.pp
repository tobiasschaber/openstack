



# Add the blockstorage (CINDER) to the computing node
class cc_openstack::roles::compute_node::blockstorage {


	Package['lvm2'] ->
	Package['cinder-volume'] ->
	File_Line['cinder_vol_config_1a'] ->
	File_Line['cinder_vol_config_1b'] ->
	File_Line['cinder_vol_config_1c'] ->
	File_Line['cinder_vol_config_2'] ->
	File_Line['cinder_vol_config_3'] ->
	File_Line['cinder_vol_config_4'] ->
	File_Line['cinder_vol_config_5'] ->
	File_Line['cinder_vol_config_6'] ->
	File_Line['cinder_vol_config_7'] ->
	File_Line['cinder_vol_config_8'] ->
	File_Line['cinder_vol_config_9'] ->
	File_Line['cinder_vol_config_10'] ->
	File_Line['cinder_vol_config_11'] ->
	File_Line['cinder_vol_config_12'] ->
	File_Line['cinder_vol_config_13'] ->
	File_Line['cinder_vol_config_14'] ->
	File_Line['cinder_vol_config_15'] ->
	Exec['cinder_volume_restart'] ->
	Exec['tgt_restart']
	
	
	

	package { 'lvm2':
		ensure => "installed",
	}
	
	package { 'cinder-volume':
		ensure => "installed",
	}

	

	
	file_line { 'cinder_vol_config_1a':
		path	=> '/etc/cinder/cinder.conf',
		line	=> "my_ip = ${ipaddress_eth1}",
	}
	
	file_line { 'cinder_vol_config_1b':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'glance_host = controller',
	}
	
	
	file_line { 'cinder_vol_config_1c':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rpc_backend = rabbit',
	}
	
	file_line { 'cinder_vol_config_2':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_host = controller',
	}
	
	file_line { 'cinder_vol_config_3':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_port = 5672',
	}
	
	file_line { 'cinder_vol_config_4':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_userid = guest',
	}
	
	file_line { 'cinder_vol_config_5':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'rabbit_password = tobias1234',
	}
	
	file_line { 'cinder_vol_config_6':
		path	=> '/etc/cinder/cinder.conf',
		line	=> '[database]',
	}
	
	file_line { 'cinder_vol_config_7':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'connection = mysql://cinder:cinder1234@controller/cinder',
	}
	
	file_line { 'cinder_vol_config_8':
		path	=> '/etc/cinder/cinder.conf',
		line	=> '[keystone_authtoken]',
	}
	
	file_line { 'cinder_vol_config_9':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_uri = http://controller:5000',
	}
	
	file_line { 'cinder_vol_config_10':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_host = controller',
	}
	
	file_line { 'cinder_vol_config_11':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_port = 35357',
	}
	
	file_line { 'cinder_vol_config_12':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_protocol = http',
	}
	
	file_line { 'cinder_vol_config_13':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'auth_tenant_name = service',
	}
	
	file_line { 'cinder_vol_config_14':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'admin_user = cinder',
	}
	
	file_line { 'cinder_vol_config_15':
		path	=> '/etc/cinder/cinder.conf',
		line	=> 'admin_password = cinder1234'
	}
	

	
	
	# restart different services
	########################################################################################
	exec { 'cinder_volume_restart':
		command => 'service cinder-volume restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'tgt_restart':
		command => 'service tgt restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	
	
}
