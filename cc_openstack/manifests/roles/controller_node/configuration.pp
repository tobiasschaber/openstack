



# Do some configuration after installation to finish
class cc_openstack::roles::controller_node::configuration {

	Exec['security_rule_1'] ->
	Exec['security_rule_2']
	

	# add basic security rules to the default rule: allow ping
	exec { 'security_rule_1':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0',
		onlyif  => 'test ! \"nova secgroup-list-rules default | grep -c icmp\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	
	# add basic security rules to the default rule: allow ssh access
	exec { 'security_rule_2':
		environment => ["OS_USERNAME=admin", "OS_PASSWORD=admin1234", "OS_TENANT_NAME=admin", "OS_AUTH_URL=http://controller:35357/v2.0"],
		command => 'nova secgroup-add-rule default tcp 22 22 0.0.0.0/0',
		onlyif  => 'test ! \"nova secgroup-list-rules default | grep -c tcp\"',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}
	


	
	
	
	
	
	
}
