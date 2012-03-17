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
    $sudoers_str = join($sudoers, ',')
    $option_str = join($option, ',')

    sudoers_line { "${name}_default":
        line    => "Defaults${sudoers_str} ${option_str}",
    }
}
