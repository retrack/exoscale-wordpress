# Install Apache

class apache2::install {

  package { 'apache2':
    ensure => present,
  }

  service { 'apache2':
    ensure  => running,
    require => Package['apache2'],
  }


  file { '/etc/apache2/sites-available/default':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/etc/puppet/modules/apache2/files/default',
    require => Package['apache2'],
    notify  => Service['apache2']
  }

  file { '/etc/apache2/mods-available/rewrite.load':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/etc/puppet/modules/apache2/files/rewrite.load',
    require => Package['apache2'],
    notify  => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure  => link,
    target  => '/etc/apache2/sites-available/default',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure  => link,
    target  => '/etc/apache2/mods-available/rewrite.load',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

}
