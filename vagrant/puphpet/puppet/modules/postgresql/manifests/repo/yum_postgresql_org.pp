# PRIVATE CLASS: do not use directly
class postgresql::repo::yum_postgresql_org inherits postgresql::repo {
  $version_parts   = split($postgresql::repo::version, '[.]')
  $package_version = "${version_parts[0]}${version_parts[1]}"
  $gpg_key_path    = "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-${package_version}"

  file { $gpg_key_path:
    source => 'puppet:///modules/postgresql/RPM-GPG-KEY-PGDG',
    before => Yumrepo['yum.postgresql.org']
  }

  if($::operatingsystem == 'Fedora') {
    $label1 = 'fedora'
    $label2 = $label1
  } else {
    $label1 = 'redhat'
    $label2 = 'rhel'
  }

  yumrepo { 'yum.postgresql.org':
    descr    => "PostgreSQL ${postgresql::repo::version} \$releasever - \$basearch",
    baseurl  => "http://yum.postgresql.org/${postgresql::repo::version}/${label1}/${label2}-\$releasever-\$basearch",
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-${package_version}",
  }

  Yumrepo['yum.postgresql.org'] -> Package<|tag == 'postgresql'|>
}
