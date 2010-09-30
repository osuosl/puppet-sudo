# Class: sudo
#
# Installs sudo and manages config files for sudo. You most likely want to
# include a sudoer_line as well, so that someone can sudo.
#
# Usage
#   include sudo
class sudo {

    require sudo::params

    package { 'sudo':
        name   => "${params::package_name}",
        ensure => "${params::package_version}",
    }

    file { 'sudo-config':
        ensure => 'present',
        path    => '/etc/sudoers',
        content => "#includedir /etc/sudoers.d\n",
        mode    => '440',
        require => Package['sudo'],
    }

}

# Define: sudo::sudoer_line
#
# Adds a file with $line as its content to /etc/sudoers.d/ , which will then be
# used by the sudo config.
#
# This is lower level that will be used on individual nodes, and some smarter
# wrappers are needed.
#
# Usage:
#   sudo::sudoer_line("
define sudo::sudoers_line ($line) {

    file { "$name":
        ensure => 'present',
        path => "/etc/sudoers.d/$name",
        content => "${line}\n",
        mode => '440',
    }

}
