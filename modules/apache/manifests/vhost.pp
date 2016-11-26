# @param site Site name
# @param docroot DocumentRoot
# See README
define apache::vhost (
  $site,
  $docroot
) {
  file { "/etc/apache2/sites-available/${site}.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('apache/vhost.epp', {
      'site'    => $site,
      'docroot' => $docroot}
    ),
  }

  file { "/etc/apache2/sites-enabled/${site}.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/${site}.conf",
    require => File["/etc/apache2/sites-available/${site}.conf"],
    notify  => Service['apache2'],
  }
}

