# Class: aptcacher
# ===========================
#
# Full description of class aptcacher here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'aptcacher':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# zeromind <zeromind@gmx.com>
#
# Copyright
# ---------
#
# Copyright 2016 zeromind.
#
class aptcacher(
  String $package_ensure='installed',
  String $package_name='apt-cacher',
  String $service_ensure='running',
  Boolean $service_enable=true,
  String $service_name='apt-cacher',
  Integer $listen_port=3142,
  Hash $config={ },
  Array $extra_options=[],
) {
  ensure_packages([$package_name], { 'ensure' => $package_ensure })
  service { 'apt-cacher':
    name       => $service_name,
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => true,
    require    => Package[$package_name],
  }
  file { 'default.apt-cacher':
    ensure  => file,
    path    => '/etc/default/apt-cacher',
    mode    => '0644',
    owner   => 0,
    group   => 0,
    content => epp('aptcacher/default.apt-cacher.epp',
      {
        'autostart'   => $service_enable,
        'extraopt'    => $extra_options,
        'daemon_port' => $listen_port,
      }
    ),
    notify => Service['apt-cacher'],
  }
  file { 'apt-cacher.conf':
    ensure  => file,
    path    => '/etc/apt-cacher/apt-cacher.conf',
    mode    => '0644',
    owner   => 0,
    group   => 0,
    content => epp('aptcacher/default.apt-cacher.epp',
      {
        'config' => $config,
      }
    ),
    notify => Service['apt-cacher'],
  }
}
