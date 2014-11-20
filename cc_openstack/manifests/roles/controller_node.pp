


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	
	Package['ntp'] ->
	Package['python-mysqldb'] ->
	Exec['install-mysql-server']
	

	
	
	package { 'ntp':
		ensure	=> "installed",
		#require	=> Exec['apt-update'],
	}
	
	package { 'python-mysqldb':
		ensure => "installed",
	}
	
	exec { 'install-mysql-server':
	
		command => "apt-get install -y mysql-server",
        cwd     => "/var/lib/tftpboot/boot/",
        creates => "/var/lib/tftpboot/boot/foreman-discovery-image-latest.el6.iso-vmlinuz",
        path    => "/usr/bin",
        timeout => 1000,
        require => File["/var/lib/tftpboot/boot"],
	
	}
	
	
	
	
	

}