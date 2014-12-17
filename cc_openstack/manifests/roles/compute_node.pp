


class cc_openstack::roles::compute_node {


	include cc_openstack::roles::compute_node::nova
	include cc_openstack::roles::compute_node::network
	

	
	Class['cc_openstack::roles::compute_node::network'] ->
	Class['cc_openstack::roles::compute_node::nova'] ->
	Notify['Starting Computing Node']
	
	
	notify { 'Starting Computing Node':}

}