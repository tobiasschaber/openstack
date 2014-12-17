

#
# this class prepares the network for computing nodes
#
# - ip address must be 172.16.0.100
# - only one network interface (the management network) with internet access. connect it to the private vlan
# - the hostname must be "controller"
#
#
#
#
class cc_openstack::roles::compute_node::network {

	File_Line['etc_hosts_cha_1'] ->
	File_Line['etc_hosts_cha_2'] ->
	File_Line['etc_hosts_cha_3']
	


	## FUNKTIONIERT DIESER MATCHER !?
	file_line { 'etc_hosts_cha_1':
		path	=> '/etc/hosts',
		match	=> '127.0.1.1	controller.local.cloud	controller',
		line	=> '#127.0.1.1	controller.local.cloud	controller',
	}
	
	file_line { 'etc_hosts_cha_2':
		path	=> '/etc/hosts',
		line	=> '# controller',
	}
	
	file_line { 'etc_hosts_cha_3':
		path	=> '/etc/hosts',
		line	=> '172.16.0.100	controller.local.cloud	controller',
	}



}