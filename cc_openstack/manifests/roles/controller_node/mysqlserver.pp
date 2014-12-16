


#
# install the mysql database.
#
# root credentials:		root/tobias1234
#
#
class cc_openstack::roles::controller_node::mysqlserver {

	Package['python-mysqldb'] ->
	Class['::mysql::server'] ->
	Exec['mysql_install_db'] ->
	File['/tmp/autosecure_mysql.sh'] ->
	Exec['mysql_autosecure'] ->
	Exec['mysql_restart']
	
	
	
	
	package { 'python-mysqldb':
		ensure => "installed",
	}

	class { '::mysql::server':
		root_password   		=> 'tobias1234',
		#restart					=> 'true',
		override_options => { 

			'mysqld' => { 
				'bind-address' => '172.16.0.100',
				'default-storage-engine' => 'innodb',
				'collation-server' => 'utf8_general_ci',
				'init-connect' => 'SET NAMES utf8',
				'character-set-server' => 'utf8',
			} , 
		}
		
	}
	
	exec { 'mysql_restart' :
		command => 'service mysql restart',
		path => ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin'],
	}

	
	exec { 'mysql_install_db':
		command => 'mysql_install_db',
		path	=> '/usr/bin/',
	}
	
	file { '/tmp/autosecure_mysql.sh':
		ensure => present,
		source => 
			'puppet:///modules/cc_openstack/autosecure_mysql.sh',
		mode => 755,
	}
	
	exec { 'mysql_autosecure':
		command	=> "/tmp/autosecure_mysql.sh",
		path	=> "/usr/bin/",
	}

	
}