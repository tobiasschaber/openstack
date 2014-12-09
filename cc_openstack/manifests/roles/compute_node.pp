


class cc_openstack::roles::compute_node {


	include cc_openstack::roles::compute_node::nova
	
	
	
	
	
	Class['cc_openstack::roles::compute_node::nova']

}