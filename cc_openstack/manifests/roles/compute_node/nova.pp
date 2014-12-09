



class cc_openstack::roles::compute_node::nova {

	Package['nova-compute-kvm']

	package { 'nova-compute-kvm':
		ensure => "installed",
	}
	

}