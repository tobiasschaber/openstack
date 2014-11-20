


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	
	Package['ntp'] ->
	Package['python-mysqldb'] ->
	Exec['install-mysql-server']
	

	
	
	package { 'ntp':
		ensure	=> "installed",
		#require	=> Exec['apt-update'],
	}
	
	package { 'python-mysqldb':
		ensure => "installed",
	}
	
	exec { 'install-mysql-server':
	
		command => "apt-get install -y mysql-server",
		path    => [ "/bin", "/usr/bin", "/sbin", "/usr/local/sbin", "/usr/sbin"],
	}
	
	
	
	
	

}