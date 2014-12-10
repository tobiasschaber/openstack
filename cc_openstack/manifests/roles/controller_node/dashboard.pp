



#
# installs the horizon dashboard (web gui)
#
#
#
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

	
	# remove the ubuntu theme because it has failures in translation and does not show menus
	exec { 'remove-ubuntu-theme':
		command => 'apt-get -y remove --purge openstack-dashboard-ubuntu-theme',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}


	# set the hostname of the controller
	file_line { 'dashboard_config_1':
		path	=> '/etc/openstack-dashboard/local_settings.py',
		match	=> '^#?OPENSTACK_HOST =.*',
		line	=> 'OPENSTACK_HOST = "controller"',
	}
	
	# restart different services
	
	
	exec { 'apache2_restart':
		command => 'service apache2 restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	exec { 'memcached_restart':
		command => 'service memcached restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	
	
}



