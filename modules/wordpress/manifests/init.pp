# Install latest Wordpress

class wordpress::install {

  # Create a directory
  file { "/wordpress":
    ensure => "directory",
  }

  # Create the Wordpress database
  exec { 'create-database':
    unless  => '/usr/bin/mysql -u root -pwordpress wordpress',
    command => '/usr/bin/mysql -u root -pwordpress --execute=\'create database wordpress\'',
  }

  exec { 'create-user':
    unless  => '/usr/bin/mysql -u wordpress -pwordpress',
    command => '/usr/bin/mysql -u root -pwordpress --execute="GRANT ALL PRIVILEGES ON wordpress.* TO \'wordpress\'@\'localhost\' IDENTIFIED BY \'wordpress\'"',
  }

  # Get a new copy of the latest wordpress release
  # FILE TO DOWNLOAD: http://wordpress.org/latest.tar.gz

  exec { 'download-wordpress': #tee hee
    command => '/usr/bin/wget http://wordpress.org/latest.tar.gz',
    cwd     => '/wordpress/',
    creates => '/wordpress/latest.tar.gz'
  }

  exec { 'untar-wordpress':
    cwd     => '/wordpress/',
    command => '/bin/tar xzvf /wordpress/latest.tar.gz',
    require => Exec['download-wordpress'],
    creates => '/wordpress/wordpress',
  }

  # Import a MySQL database for a basic wordpress site.
  file { '/tmp/wordpress-db.sql':
    ensure => file,
    path => '/tmp/wordpress-db.sql',
    content => template('wordpress/wordpress-db.sql.erb')
  }

  exec { 'load-db':
    command => '/usr/bin/mysql -u wordpress -pwordpress wordpress < /tmp/wordpress-db.sql && touch /wordpress/db-created',
    creates => '/wordpress/db-created',
  }

  # Copy a working wp-config.php file for the wordpress setup.
  file { '/wordpress/wordpress/wp-config.php':
    source => 'puppet:///modules/wordpress/wp-config.php'
  }

}
