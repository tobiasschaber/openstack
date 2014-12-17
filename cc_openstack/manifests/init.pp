
# Achtung wichtige Infos
# puppet muss zwischen Installation des OS und Puppet-Run auf dem Client mit "puppet agent --enable" aktiviert werden
# Der Emu-Typ muss auf allen compute nodes von "KVM" auf "qemu" gesetzt werden, siehe http://docs.openstack.org/icehouse/install-guide/install/apt/content/nova-compute.html Punkt 6 ff
# server.local.cloud musste ich auch ein paar mal in die /etc/hosts eintragen auf 10.0.1.175	server.local.cloud
# Das Default-Network kann erst erstellt werden, wenn der erste computing node installiert wurde, daher wurde es auskommentiert!
#
#
#




class cc_openstack {

	# default is controller node
	include cc_openstack::roles::controller_node

}

include cc_openstack