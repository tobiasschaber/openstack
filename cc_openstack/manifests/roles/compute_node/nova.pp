



class cc_openstack::roles::compute_node::nova {

	Exec['perform-apt-get-update'] ->	
	Package['nova-compute-kvm']
	
	

	exec { 'perform-apt-get-update':
		command => 'apt-get update',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}


	package { 'nova-compute-kvm':
		ensure => "installed",
	}
		

}