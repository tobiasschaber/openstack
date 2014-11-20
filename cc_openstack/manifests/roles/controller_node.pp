


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	
	Package['ntp'] ->
	Package['python-mysqldb']
	

	
	
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

	
	
	
	
	
	

}