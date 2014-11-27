


class cc_openstack::roles::controller_node {

	include cc_openstack::roles::controller_node::network
	include cc_openstack::roles::controller_node::keystone
	include cc_openstack::roles::controller_node::clienttools
	
	
	Class['cc_openstack::roles::controller_node::network'] ->
	Package['expect'] ->
	Package['ntp'] ->
	Package['python-mysqldb'] ->
	Class['::mysql::server'] ->
	Exec['mysql_install_db'] ->
	File['/tmp/autosecure_mysql.sh'] ->
	Exec['mysql_autosecure'] ->
	Exec['mysql_restart'] ->
	Package['rabbitmq-server'] ->
	Exec['set_rabbitmq_pw'] ->
	Class['cc_openstack::roles::controller_node::keystone'] ->
	Class['cc_openstack::roles::controller_node::clienttools']
	
	
	

	package { 'expect':
		ensure => "installed",
	}
	
	package { 'ntp':
		ensure	=> "installed",
	}
	
	package { 'python-mysqldb':
		ensure => "installed",
	}

	class { '::mysql::server':
		root_password   		=> 'tobias1234',
		#restart					=> 'true',
		override_options => { 

			'mysqld' => { 
				'bind-address' => '10.0.0.11',
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

	
	package { 'rabbitmq-server':
		ensure => 'installed',
	}
	
	exec { 'set_rabbitmq_pw':
		#command => 'rabbitmqctl change_password guest tobias1234',
		command => 'su rabbitmq -s /bin/sh -c "/usr/lib/rabbitmq/bin/rabbitmqctl change_password guest tobias1234"',
		path	=> '/bin/',
	}
	




	
	## AKTUELLER STAND
	## DER MYSQL_RESTART SCHEINT NICHT ZU KLAPPEN, LETZTES MAL HAT ER BEI "STOPPED" STATUS NICHT MEHR STARTEN KÖNNEN
	# DONE ## AUSSERDEM SCHEINT DER keystone-db-user NOCH "root" ZU SEIN ANSTELLE "keystone"
	

	

	

}