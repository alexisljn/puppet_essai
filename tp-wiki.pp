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

define install_site($siteName, $source, $owner) {
  file {
    $siteName:
      ensure  => directory,
      path    => "/var/www/${siteName}",
      source  => $source,
      recurse => true,
      owner   => $owner,
      group   => $owner,
      require => File['move-dokuwiki']
  }
}

node server0 {
  include dokuwiki
  install_site {
    'politique.wiki':
      siteName => 'politique.wiki',
      source   => '/usr/src/dokuwiki',
      owner    => 'www-data'
    ;
    'tajineworld.com':
      siteName => 'tajineworld.com',
      source   => '/usr/src/dokuwiki',
      owner    => 'www-data'
    ;
    'lemondedelaraclette.fr':
      siteName => 'lemondedelaraclette.fr',
      source   => '/usr/src/dokuwiki',
      owner    => 'www-data'
  }
}

node server1 {
  include dokuwiki
  install_site {
    'recettes.wiki':
      siteName => 'recettes.wiki',
      source   => '/usr/src/dokuwiki',
      owner    => 'www-data'
  }
}
