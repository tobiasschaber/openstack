


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	include cc_openstack::roles::controller_node::keystone
	include cc_openstack::roles::controller_node::clienttools
	include cc_openstack::roles::controller_node::mysqlserver
	include cc_openstack::roles::controller_node::rabbitmqserver
	
	
	Class['cc_openstack::roles::controller_node::network'] ->
	Package['expect'] ->
	Package['ntp'] ->
	Class['cc_openstack::roles::controller_node::mysqlserver'] ->
	Class['cc_openstack::roles::controller_node::rabbitmqserver'] ->
	Class['cc_openstack::roles::controller_node::keystone'] ->
	Class['cc_openstack::roles::controller_node::clienttools']
	
	
	

	package { 'expect':
		ensure => "installed",
	}
	
	package { 'ntp':
		ensure	=> "installed",
	}
	
	

	
	## AKTUELLER STAND
	## DER MYSQL_RESTART SCHEINT NICHT ZU KLAPPEN, LETZTES MAL HAT ER BEI "STOPPED" STATUS NICHT MEHR STARTEN KÖNNEN
	# DONE ## AUSSERDEM SCHEINT DER keystone-db-user NOCH "root" ZU SEIN ANSTELLE "keystone"
	

	

	

}