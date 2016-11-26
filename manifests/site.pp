node 'web.pomes.pro' {
  $site=$fqdn;
  $docroot="/var/www/${site}";
  $users=hiera('webusers');

  class { 'baseconfig':
    agentmode => 'cron';
  }

  class {
    'apache':;
    'php':;
  }

  class { 'mysql::server':
    root_password => 'super_secure_password';
  }

  apache::vhost{"${site}":
    site    => $site,
    docroot => $docroot,
  }

  apache::htpasswd{'htpasswd':
    filepath => '/etc/apache2/htpasswd',
    users    => hiera('webusers'),
  }

  apache::htaccess{"${docroot}-htaccess":
    filepath => '/etc/apache2/htpasswd',
    docroot  => $docroot,
  }

  file { $docroot:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file {"${docroot}/index.php":
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => "<?php echo \"Running from $environment\" ?>",
  }
}

node 'puppet.pomes.pro' {
  class { 'baseconfig':
    agentmode => 'cron';
  }
}
