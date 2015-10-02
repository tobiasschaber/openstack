



# Install all Client-Tools. The Client-Tools are neeed if you want to communicate with the server components via a command line interface.
# So if you install the Client-Tools you have some command line tools available.
# You can install the command line tools on any other machine if you like.
class cc_openstack::roles::controller_node::clienttools {

#	Exec['install_pip'] ->
	Package['python-ceilometerclient'] ->
	Package['python-cinderclient'] ->
#	Package['install-python-glanceclient'] ->	#	is already installed in another module
	Package['python-heatclient'] ->
	Package['python-keystoneclient'] ->
	Package['python-neutronclient'] ->
#	Package['python-novaclient'] ->				#	is already installed in another module
	Package['python-swiftclient'] ->
	Package['python-troveclient']
	
	
	# install pip, an alternative package manager. I'm not sure if we still use pip at any
	# point or if we replaced its usage with apt-get, so I wont remove it now	
#	exec { 'install_pip':
#		command => 'easy_install pip',
#		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
#	}

	# ceilometer client
	package { 'python-ceilometerclient':
		ensure => "installed",
	}
	
	# cinderclient
	package { 'python-cinderclient':
		ensure => "installed",
	}

# already installed in imageservice... maybe need to separate this better later!	
#	package { 'install-python-glanceclient':
#		name => "python-glanceclient",
#		ensure => "installed",
#	}
	
	# heatclient
	package { 'python-heatclient':
		ensure => "installed",
	}
	
	# keystone client. used to add and query keystone resources like users, roles, tenants, endpoints and services via the command line
	package { 'python-keystoneclient':
		ensure => "installed",
	}
	
	# neutron client
	package { 'python-neutronclient':
		ensure => "installed",
	}

# already installed in computeservice... maybe need to separate this better later!	
#	package { 'python-novaclient':
#		ensure => "installed",
#	}
	
	# swift client
	package { 'python-swiftclient':
		ensure => "installed",
	}
	
	# trove client
	package { 'python-troveclient':
		ensure => "installed",
	}
	
	
	
}
