# Class: sudo
#
# Installs sudo and manages config files for sudo. You most likely want to
# include a sudoer_line as well, so that someone can sudo.
#
# Usage
#   include sudo
#
class sudo {
    include sudo::params

    package { 'sudo':
        name   => "${params::package_name}",
        ensure => present,
    }

    file {
        'sudoers':
            ensure  => present,
            path    => '/etc/sudoers',
            content => '#includedir /etc/sudoers.d\n',
            mode    => 400,
            require => Package['sudo'],
        'sudoers.d':
            path    => '/etc/sudoers.d',
            ensure  => directory,
            recurse => true,
            purge   => true,
            force   => true,
    }
}

