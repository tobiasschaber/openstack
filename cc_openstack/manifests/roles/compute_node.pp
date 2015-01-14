


class cc_openstack::roles::compute_node {


	include cc_openstack::roles::compute_node::nova
	include cc_openstack::roles::compute_node::network
	include cc_openstack::roles::compute_node::blockstorage
	

	
	Class['cc_openstack::roles::compute_node::network'] ->
	Class['cc_openstack::roles::compute_node::nova'] ->
	Class['cc_openstack::roles::compute_node::blockstorage'] ->
	Notify['Starting Computing Node']
	
	
	notify { 'Starting Computing Node':}

}