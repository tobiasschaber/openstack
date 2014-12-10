

#
# install rabbitmq as messaging backend system
#
# rabbitmy user:	guest/tobias1234
#
class cc_openstack::roles::controller_node::rabbitmqserver {

	Package['rabbitmq-server'] ->
	Exec['set_rabbitmq_pw']
	
	
	package { 'rabbitmq-server':
		ensure => 'installed',
	}
	
	# set the default password for guest
	exec { 'set_rabbitmq_pw':
		#command => 'rabbitmqctl change_password guest tobias1234',
		command => 'su rabbitmq -s /bin/sh -c "/usr/lib/rabbitmq/bin/rabbitmqctl change_password guest tobias1234"',
		path	=> '/bin/',
	}
	

	
	
}