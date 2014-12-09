


class cc_openstack::roles::controller_node::clienttools {

	Exec['install_pip'] ->
	Package['python-ceilometerclient'] ->
	Package['python-cinderclient'] ->
#	Package['install-python-glanceclient'] ->
	Package['python-heatclient'] ->
	Package['python-keystoneclient'] ->
	Package['python-neutronclient'] ->
#	Package['python-novaclient'] ->
	Package['python-swiftclient'] ->
	Package['python-troveclient']
	
	
	exec { 'install_pip':
		command => 'easy_install pip',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	package { 'python-ceilometerclient':
		ensure => "installed",
	}
	
	package { 'python-cinderclient':
		ensure => "installed",
	}

# already installed in imageservice... maybe need to separate this better later!	
#	package { 'install-python-glanceclient':
#		name => "python-glanceclient",
#		ensure => "installed",
#	}
	
	package { 'python-heatclient':
		ensure => "installed",
	}
	
	package { 'python-keystoneclient':
		ensure => "installed",
	}
	
	package { 'python-neutronclient':
		ensure => "installed",
	}

# already installed in computeservice... maybe need to separate this better later!	
#	package { 'python-novaclient':
#		ensure => "installed",
#	}
	
	package { 'python-swiftclient':
		ensure => "installed",
	}
	
	package { 'python-troveclient':
		ensure => "installed",
	}
	
	
	
}
