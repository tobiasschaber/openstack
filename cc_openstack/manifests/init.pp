
# Achtung wichtige Infos
# puppet muss zwischen Installation des OS und Puppet-Run auf dem Client mit "puppet agent --enable" aktiviert werden
# Der Emu-Typ muss auf allen compute nodes von "KVM" auf "qemu" gesetzt werden, siehe http://docs.openstack.org/icehouse/install-guide/install/apt/content/nova-compute.html Punkt 6 ff
# server.local.cloud musste ich auch ein paar mal in die /etc/hosts eintragen auf 10.0.1.175	server.local.cloud
# Das Default-Network kann erst erstellt werden, wenn der erste computing node installiert wurde, daher wurde es auskommentiert!
#
#
#


# PRE INSTALLATION
# Vor der Installation ist im Foreman DHCP Server unter dem File /etc/dhcp/dhcpd.conf im unteren Block von "subhet" nach dem pool{} block folgendes einzutragen:
#
#  host controller {
#                hardware ethernet 00:23:7d:be:fd:cc;
#                fixed-address 172.16.0.100;
#  }
#
# dadurch bekommt der server immer die korrekte IP.
#
#
# Außerdem: unter /etc/foreman-proxy/settings.yml alle Zeilen unter trusted_hosts auskommentieren! ANsonsten gibts nur 403 Forbidden Fehler beim Aufruf von
# http://10.0.1.175:8000/dhcp/172.16.0.0
#:trusted_hosts:
##  - localhost
##  - 10.0.1.173




class cc_openstack {

	# default is controller node
	include cc_openstack::roles::controller_node

}

include cc_openstack