# @param website Site name
# @param docroot DocumentRoot
# See README
define apache::vhost (
  $website,
  $docroot
) {
  file { "/etc/apache2/sites-available/${website}.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('apache/vhost.epp', {
      'website' => $website,
      'docroot' => $docroot}
    ),
  }

  file { "/etc/apache2/sites-enabled/${website}.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/${website}.conf",
    require => File["/etc/apache2/sites-available/${website}.conf"],
    notify  => Service['apache2'],
  }
}

