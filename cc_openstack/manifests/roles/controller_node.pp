


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	
	Package['ntp'] ->
	Package['python-mysqldb'] ->
	Class['::mysql::server'] ->
	Exec['mysql_install_db'] ->
	Package['rabbitmq-server'] ->
	Exec['set_rabbitmq_pw']
	

	package { 'ntp':
		ensure	=> "installed",
		#require	=> Exec['apt-update'],
	}
	
	package { 'python-mysqldb':
		ensure => "installed",
	}

	class { '::mysql::server':
		root_password   		=> 'tobias1234',
		override_options => { 

			'mysqld' => { 
				'bind-address' => '10.0.1.11',
				'default-storage-engine' => 'innodb',
				'collation-server' => 'utf8_general_ci',
				'init-connect' => 'SET NAMES utf8',
				'character-set-server' => 'utf8',
				
			} , 
		}
	}

	
	exec { 'mysql_install_db':
		command => "mysql_install_db",
		path	=> "/usr/bin/",
	}

	
	package { 'rabbitmq-server':
		ensure => 'installed',
	}
	
	exec { 'set_rabbitmq_pw':
		command => "rabbitmqctl change_password guest tobias1234",
		path	=> "/usr/bin/",
	}
	

	

}