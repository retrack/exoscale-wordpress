$extlookup_datadir = "/etc/puppet/config"
$extlookup_precedence = [ "common" ]

exec { 'apt_update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

include git
include nginx
include php5
include mysql
include wordpress
include nginx::wordpress
include php5::wordpress
