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
