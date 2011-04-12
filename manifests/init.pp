# Class: sudo
#
# Installs sudo and manages config files for sudo. You most likely want to
# include a sudoer_line as well, so that someone can sudo.
#
# Usage
#   include sudo
#
class sudo {
    include concat::setup

    require sudo::params

    package { 'sudo':
        name   => "${params::package_name}",
        ensure => present,
    }

    concat { "${sudo::params::sudoers_file}":
        owner => root,
        group => root,
        mode => 440,
        require => Package['sudo'],
    }
}

# Define: sudo::sudoer_line
#
# Adds a line to /etc/sudoers via concat.
#
# This is lower level than will be used on individual nodes, and some smarter
# wrappers are provided. Consider using sudo::sudoer and sudo::default.
#
# Parameters
#   $line - The line to put in sudoers.
#
# Usage:
#   # Give the group wheel sudo access the hard way.
#   sudo::sudoer_line{"wheel_sudo":
#       $line => "%wheel ALL=(ALL) ALL",
#   }
#
define sudo::sudoers_line ($line) {

    concat::fragment { "$name":
        target => "sudoers",
        content => "${line}\n",
        require => Concat["${sudo::params::sudoers_file}"],
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
#   sudo::sudoer {"%wheel":}
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

    sudoers_line { "${name}_sudoer":
        line    => "${name} ALL=(${users_str}) ${passwd}${commands_str}",
    }
}

# Define: sudo::default
#
# Defines defaults for sudo
#
# Parameters:
#   $name - The name variable. Only used as a part of the file name.
#
#   $option - The option to give to defaults. May be a string or an array of
#     strings. Required.
#
#   $sudoers - The list of sudoers this default applies to. If none given, then
#     the default is global. May be a string or an array of strings. Sudoers
#     with % before their name refer to groups.
#
# Usage:
#   sudo::default { 'env_reset':
#       option => 'env_reset',
#   }
#
#   sudo::default { 'wheel_env':
#       option  => '!env_reset',
#       sudoers => '%wheel',
#   }
#
#   sudo::default { 'admins':
#       option => ['timestamp_timeout=10', '!tty_tickets'],
#       sudoers => ['bob', 'fred', 'alice'],
#   }
#
define sudo::default ($option, $sudoers="") {
    # Hack hack - http://projects.puppetlabs.com/issues/show/2990
    $sudoers_str = $sudoers ? {
        ""      => "",
        default => inline_template(
            "<%= if sudoers.is_a?(String) then (':'+sudoers); else (':'+sudoers.join(',')) end %>"
        )
    }
    $option_str = inline_template("<%= if option.is_a?(String) then option; else option.join(',') end %>")

    sudoers_line { "${name}_default":
        line    => "Defaults${sudoers_str} ${option_str}",
    }
}
