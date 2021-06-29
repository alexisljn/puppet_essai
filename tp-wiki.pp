class dokuwiki {
  package {
    'apache2':
      ensure   => present,
    #name     => 'apache2',
    #provider => apt
  }

  package {
    'php7.3':
      ensure   => present
  }

  file {
    'download-dokuwiki':
      ensure => present,
      path   => '/usr/src/dokuwiki.tgz',
      source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
  }

  file {
    'move-dokuwiki':
      ensure  => present,
      path    => '/usr/src/dokuwiki',
      source  => '/usr/src/dokuwiki-2020-07-29',
      recurse => true,
      require => Exec['unzip-dokuwiki']
  }

  exec {
    'unzip-dokuwiki':
      command => 'tar xavf dokuwiki.tgz',
      path    => ['/usr/bin'],
      cwd     => '/usr/src',
      require => File['download-dokuwiki'],
      unless  => 'test -d /usr/src/dokuwiki-2020-07-29/'
  }

}

class politiquewiki {
  file {
  'copy-dokuwiki-recettes.wiki':
    ensure  => directory,
    path    => '/var/www/recettes.wiki',
    source  => '/usr/src/dokuwiki',
    recurse => true,
    owner   => 'www-data',
    group   => 'www-data',
    require => File['move-dokuwiki']
  }
}

class recetteswiki {
  file {
  'create directory for politique.wiki':
    ensure  => directory,
    path    => '/var/www/politique.wiki',
    source  => '/usr/src/dokuwiki',
    recurse => true,
    owner   => 'www-data',
    group   => 'www-data',
    require => File['move-dokuwiki']
  }
}

node server0 {
  include dokuwiki
  include politiquewiki
}

node server1 {
  include dokuwiki
  include recetteswiki
}
