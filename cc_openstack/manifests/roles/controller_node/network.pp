

#
# this class provides the network for controller node
#
# - ip address must be 172.16.0.100
# - only one network interface (the management network) with internet access. connect it to the private vlan
# - the hostname must be "controller"
#
#
#
#
class cc_openstack::roles::controller_node::network {

#	File_Line['append_mgmt_interface_1'] ->
#	File_Line['append_mgmt_interface_2'] ->
#	File_Line['append_mgmt_interface_3'] ->
#	File_Line['append_mgmt_interface_4'] ->
#	File_Line['append_mgmt_interface_5'] ->
#	Exec['ifup_eth1'] ->
	File_Line['etc_hosts_change_1'] ->
	File_Line['etc_hosts_change_2'] ->
	File_Line['etc_hosts_change_3']
	

#	file_line { 'append_mgmt_interface_1':
#		path => '/etc/network/interfaces',
#		line => 'auto eth1',
#	}
	
#	file_line { 'append_mgmt_interface_2':
#		path => '/etc/network/interfaces',
#		line => 'iface eth1 inet static',
#	}
	
#	file_line { 'append_mgmt_interface_3':
#		path => '/etc/network/interfaces',
#		line => '	address 10.0.0.11',
#	}
	
#	file_line { 'append_mgmt_interface_4':
#		path => '/etc/network/interfaces',
#		line => '	netmask 255.255.255.0',
#	}
	
#	file_line { 'append_mgmt_interface_5':
#		path => '/etc/network/interfaces',
#		line => '	gateway 10.0.0.1',
#	}
	
#	exec { "ifup_eth1":
#       command => "ifup eth1",
#       path	=> "/sbin/",
#	}
	

	## FUNKTIONIERT DIESER MATCHER !?
	file_line { 'etc_hosts_change_1':
		path	=> '/etc/hosts',
		match	=> '127.0.1.1	controller.local.ccloud	controller',
		line	=> '#127.0.1.1	controller.local.ccloud	controller',
	}
	
	file_line { 'etc_hosts_change_2':
		path	=> '/etc/hosts',
		line	=> '# controller',
	}
	
	file_line { 'etc_hosts_change_3':
		path	=> '/etc/hosts',
		line	=> '172.16.0.100	controller.local.ccloud	controller',
	}



}