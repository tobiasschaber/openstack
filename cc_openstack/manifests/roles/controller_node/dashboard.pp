


class cc_openstack::roles::controller_node::dashboard {

	Exec['apt-get-update'] ->
	Package['apache2'] ->
	Package['memcached'] ->
	Package['libapache2-mod-wsgi'] ->
	Package['openstack-dashboard'] ->
	Exec['remove-ubuntu-theme'] ->
	File_Line['dashboard_config_1'] ->
	Exec['apache2_restart'] ->
	Exec['memcached_restart']
	
	

	
	exec { 'apt-get-update':
		command => 'apt-get update',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	package { 'apache2':
		ensure => "installed",
	}

	package { 'memcached':
		ensure => "installed",
	}
	
	package { 'libapache2-mod-wsgi':
		ensure => "installed",
	}
	
	package { 'openstack-dashboard':
		ensure => "installed",
	}

	exec { 'remove-ubuntu-theme':
		command => 'apt-get remove --purge openstack-dashboard-ubuntu-theme',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}


	file_line { 'dashboard_config_1':
		path	=> '/etc/openstack-dashboard/local_settings.py',
		match	=> '^#?OPENSTACK_HOST =.*',
		line	=> 'OPENSTACK_HOST = "controller"',
	}
	
	
	exec { 'apache2_restart':
		command => 'service apache2 restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'memcached_restart':
		command => 'service memcached restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	
	
}



