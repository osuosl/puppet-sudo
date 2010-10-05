# Class: sudo
#
# Installs sudo and manages config files for sudo. You most likely want to
# include a sudoer_line as well, so that someone can sudo.
#
# Usage
#   include sudo
#
class sudo {

    require sudo::params

    package { 'sudo':
        name   => "${params::package_name}",
        ensure => "${params::package_version}",
    }

    file { 'sudoers':
        ensure => 'present',
        path    => '/etc/sudoers',
        content => "#includedir /etc/sudoers.d\n",
        mode    => '440',
        require => Package['sudo'],
    }

    file { 'sudoers.d':
        path    => '/etc/sudoers.d',
        ensure  => 'directory',
        recurse => true,
        purge   => true,
        force   => true,
    }
}

# Define: sudo::sudoer_line
#
# Adds a file with $line as its content to /etc/sudoers.d/ , which will then be
# used by the sudo config.
#
# This is lower level that will be used on individual nodes, and some smarter
# wrappers are needed. You probably won't be using this directly.
#
# Usage:
#   sudo::sudoer_line("%wheel ALL=(ALL) ALL")
#
define sudo::sudoers_line ($line) {

    file { "$name":
        ensure => 'present',
        path => "/etc/sudoers.d/$name",
        content => "${line}\n",
        mode => '440',
    }
}

# Define: sudo::sudoer
#
# Grants full sudo access to the named user or group.
#
# Parameters:
#   $name - The name variable. This user/group will be granted sudo access.
#     If the name starts with a '%', it refers to a group, otherwise a user.
#
#   $users - The list of users that $name is allowed to 'impersonate' with
#     sudo.  Default: "ALL".
#
#   $commands - The list of commands that $name is allowed to run with sudo.
#     Default "ALL".
#
#   $password - If true, a password will be required for sudo. If false, a
#     password will not be required. Default: true.
#
# Usage
#   # Give the group 'wheel' full access to password protected sudo.
#   sudo::sudoer {"%wheel"}
#
#   # Give the user 'mike' access to impersonate only 'apache' without a password
#   sudo::sudoer {"mike": $users="apache", password => false,}
#
define sudo::sudoer ($users="ALL", $commands="ALL", $password=true) {
    $passwd = $password ? {
        false   => "NOPASSWD:",
        default => "PASSWD:",
    }
    # Hack hack - http://projects.puppetlabs.com/issues/show/2990
    $users_str = inline_template("<%= if users.is_a?(String) then users; else users.join(',') end %>")
    $commands_str = inline_template("<%= if commands.is_a?(String) then commands; else commands.join(',') end %>")

    sudoers_line { "${name}_sudo":
        line    => "${name} ALL=(${users_str}) ${passwd}${commands_str}",
        require => File['sudoers.d']
    }
}
