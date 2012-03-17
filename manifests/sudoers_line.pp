# Define: sudo::sudoer_line
#
# Adda file with $line as its content to /etc/sudoers.d/, which will the be
# included be /etc/sudoers.
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

    file { "${name}":
        ensure => present,
        path   => "etc/sudoers.d/${name}",
        content => "${line}\n",
    }
}
