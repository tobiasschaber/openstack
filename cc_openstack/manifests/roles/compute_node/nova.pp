



class cc_openstack::roles::compute_node::nova {

	Exec['perform-apt-get-update'] ->	
	Package['nova-compute-kvm'] ->
	
	File_Line['nova_conf_1a'] ->
	File_Line['nova_conf_1b'] ->
	File_Line['nova_conf_1c'] ->
	File_Line['nova_conf_1d'] ->
	File_Line['nova_conf_1e'] ->
	File_Line['nova_conf_1f'] ->
	File_Line['nova_conf_1g'] ->
	File_Line['nova_conf_1h'] ->
	File_Line['nova_conf_1i'] ->
	File_Line['nova_conf_1j'] ->
	File_Line['nova_conf_1k'] ->
	File_Line['nova_conf_1l'] ->
	File_Line['nova_conf_1m'] ->
	File_Line['nova_conf_1n'] ->
	File_Line['nova_conf_1o'] ->
	File_Line['nova_conf_1p'] ->
	File_Line['nova_conf_1q'] ->
	File_Line['nova_conf_1r'] ->
	File_Line['nova_conf_1s'] ->
	File_Line['nova_conf_1t'] ->
	File['/var/lib/nova/nova.sqlite'] ->
	Exec['nova-compute-restart-now']
	

	exec { 'perform-apt-get-update':
		command => 'apt-get update',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}


	package { 'nova-compute-kvm':
		ensure => "installed",
	}
		
	file_line { 'nova_conf_1a':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_strategy = keystone',
	}
	
	file_line { 'nova_conf_1b':
		path	=> '/etc/nova/nova.conf',
		line	=> 'rpc_backend = rabbit',
	}
	
	file_line { 'nova_conf_1c':
		path	=> '/etc/nova/nova.conf',
		line	=> 'rabbit_host = controller',
	}
	
	file_line { 'nova_conf_1d':
		path	=> '/etc/nova/nova.conf',
		line	=> 'rabbit_password = tobias1234',
	}
		
		
	#TODO myip? soll er doch selber wissen bitte... TODO
	file_line { 'nova_conf_1e':
		path	=> '/etc/nova/nova.conf',
		line	=> 'my_ip = 10.0.0.25',
	}
	
	file_line { 'nova_conf_1f':
		path	=> '/etc/nova/nova.conf',
		line	=> 'vnc_enabled = True',
	}
	
	file_line { 'nova_conf_1'g:
		path	=> '/etc/nova/nova.conf',
		line	=> 'vncserver_listen = 0.0.0.0',
	}
	
	file_line { 'nova_conf_1h':
		path	=> '/etc/nova/nova.conf',
		line	=> 'vncserver_proxyclient_address = 10.0.0.25',
	}
	
	file_line { 'nova_conf_1i':
		path	=> '/etc/nova/nova.conf',
		line	=> 'novncproxy_base_url = http://controller:6080/vnc_auto.html',
	}

	file_line { 'nova_conf_1j':
		path	=> '/etc/nova/nova.conf',
		line	=> 'glance_host = controller',
	}
	

		
	
	file_line { 'nova_conf_1k':
		path	=> '/etc/nova/nova.conf',
		line	=> '[database]',
	}
	
		file_line { 'nova_conf_1l':
		path	=> '/etc/nova/nova.conf',
		line	=> 'connection = mysql://nova:nova1234@controller/nova',
	}

	file_line { 'nova_conf_1m':
		path	=> '/etc/nova/nova.conf',
		line	=> '[keystone_authtoken]',
	}
	
	file_line { 'nova_conf_1n':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_uri = http://controller:5000',
	}
	
	file_line { 'nova_conf_1o':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_host = controller',
	}
	
	file_line { 'nova_conf_1p':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_port = 35357',
	}
	
	file_line { 'nova_conf_1q':
		path	=> '/etc/nova/nova.conf',
		line	=> 'auth_protocol = http',
	}
	
	file_line { 'nova_conf_1r':
		path	=> '/etc/nova/nova.conf',
		line	=> 'admin_tenant_name = service',
	}
	
	file_line { 'nova_conf_1s':
		path	=> '/etc/nova/nova.conf',
		line	=> 'admin_user = nova',
	}
	
	file_line { 'nova_conf_1t':
		path	=> '/etc/nova/nova.conf',
		line	=> 'admin_password = nova1234',
	}
	
	
	file { '/var/lib/nova/nova.sqlite':
		ensure => absent,
	}
	
	exec { 'nova-compute-restart-now':
		command => 'service nova-compute restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	



	
		

}