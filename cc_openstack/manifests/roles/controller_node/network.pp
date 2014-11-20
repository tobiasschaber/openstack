


class cc_openstack::roles::controller_node::network {

	File_Line['append_mgmt_interface_1'] ->
	File_Line['append_mgmt_interface_2'] ->
	File_Line['append_mgmt_interface_3'] ->
	File_Line['append_mgmt_interface_4'] ->
	File_Line['append_mgmt_interface_5']
	

	file_line { 'append_mgmt_interface_1':
		path => '/etc/network/interfaces',
		line => 'auto eth1',
	}
	
	file_line { 'append_mgmt_interface_2':
		path => '/etc/network/interfaces',
		line => 'iface eth1 inet static',
	}
	
	file_line { 'append_mgmt_interface_3':
		path => '/etc/network/interfaces',
		line => '	address 10.0.0.11',
	}
	
	file_line { 'append_mgmt_interface_4':
		path => '/etc/network/interfaces',
		line => '	netmask 255.255.255.0',
	}
	
	file_line { 'append_mgmt_interface_5':
		path => '/etc/network/interfaces',
		line => '	gateway 10.0.0.1',
	}



}