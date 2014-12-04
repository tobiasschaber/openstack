


class cc_openstack::roles::controller_node::clienttools {

	Exec['install_pip'] ->
	Package['install_client_ceilometer'] ->
	Exec['install_client_cinder'] ->
	Exec['install_client_glance'] ->
	Exec['install_client_heat'] ->
	Exec['install_client_keystone'] ->
	Exec['install_client_neutron'] ->
	Exec['install_client_nova'] ->
	Exec['install_client_swift'] ->
	Exec['install_client_trove']
	
	
	exec { 'install_pip':
		command => 'easy_install pip',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	package { 'python-ceilometerclient':
		ensure => "installed",
	}
	
#	exec { 'install_client_ceilometer':
#		command => 'pip install python-ceilometerclient',
#		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
#	}
	
	exec { 'install_client_cinder':
		command => 'pip install python-cinderclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_glance':
		command => 'pip install python-glanceclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_heat':
		command => 'pip install python-heatclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_keystone':
		command => 'pip install python-keystoneclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_neutron':
		command => 'pip install python-neutronclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_nova':
		command => 'pip install python-novaclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_swift':
		command => 'pip install python-swiftclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
	
	exec { 'install_client_trove':
		command => 'pip install python-troveclient',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin', '/usr/local/bin/'],
	}
}
