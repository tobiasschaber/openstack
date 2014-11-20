


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	
	Package['ntp'] ->
	Package['python-mysqldb'] ->
	Exec['install-mysql-server'] ->
	File_Line['setup_mysql_server_1']
	

	
	
	package { 'ntp':
		ensure	=> "installed",
		#require	=> Exec['apt-update'],
	}
	
	package { 'python-mysqldb':
		ensure => "installed",
	}
	
#	exec { 'install-mysql-server':
#		command => "apt-get install -y mysql-server",
#		path    => [ "/bin", "/usr/bin", "/sbin", "/usr/local/sbin", "/usr/sbin"],
#	}
	
#	file_line { 'setup_mysql_server_1' :
#		path	=> '/etc/mysql/my.cnf',
#		match	=> 'bind-address		= 127.0.0.1',
#		line	=> 'bind-address		= 10.0.0.11',
#	}

	class { '::mysql::server':
		root_password   => 'tobias1234',
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