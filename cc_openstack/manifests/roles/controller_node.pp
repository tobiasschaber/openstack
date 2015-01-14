

#
# This is the main part (and entry point) if you want to install a controller node.
# The controller node contains the following parts:
#  - MySQL Server
#  - Client Tools
#  - Keystone (User and Authentication Services)
#  - Compute Service (Host System)
#  - Dashboard (Horizon)
#  - Image Service (Glance)
#
# The server needs two network interfaces and will get the static IP 172.16.0.100 and hostname "controller"
#
class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	include cc_openstack::roles::controller_node::keystone
	include cc_openstack::roles::controller_node::clienttools
	include cc_openstack::roles::controller_node::mysqlserver
	include cc_openstack::roles::controller_node::rabbitmqserver
	include cc_openstack::roles::controller_node::imageservice
	include cc_openstack::roles::controller_node::computeservice
	include cc_openstack::roles::controller_node::dashboard
	include cc_openstack::roles::controller_node::configuration
	include cc_openstack::roles::controller_node::blockstorage
	
	
	Class['cc_openstack::roles::controller_node::network'] ->
	Package['expect'] ->
	Package['ntp'] ->
	Class['cc_openstack::roles::controller_node::mysqlserver'] ->
	Class['cc_openstack::roles::controller_node::rabbitmqserver'] ->
	Class['cc_openstack::roles::controller_node::keystone'] ->
	Class['cc_openstack::roles::controller_node::clienttools'] ->
	Class['cc_openstack::roles::controller_node::imageservice'] ->
	Class['cc_openstack::roles::controller_node::computeservice'] ->
	Class['cc_openstack::roles::controller_node::dashboard'] ->
	Class['cc_openstack::roles::controller_node::configuration'] ->
	Class['cc_openstack::roles::controller_node::blockstorage']
	
	
	

	package { 'expect':
		ensure => "installed",
	}
	
	package { 'ntp':
		ensure	=> "installed",
	}
	
}
