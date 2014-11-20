


class cc_openstack::roles::controller_node {

	#include cc_openstack::roles::controller_node::network
	
	package { 'ntp':
		ensure	=> "installed",
		#require	=> Exec['apt-update'],
	}
	
	
	
	
	
	

}