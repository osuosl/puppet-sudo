# Sudoers entry 
#
# == Parameters
#
# If no aliases are set they all default to "ALL" in the user specification. If
# "cmnd_alias" is set, the template will prefer that over "command". If
# "command" is empty, then the user specification will be not be printed.
#
# [*ensure*]
#   Defaults to `present`.
#
# [*comment*]
#   Comment included in the file
#
# [*user_alias*]
#   User_Alias in sudoers. Accepts either a single string or an array. The
#   "namevar" will be the name of the alias.
#
# [*runas_alias*]
#   Runas_Alias in sudoers. Accepts either a single string or an array. The
#   "namevar" will be the name of the alias.
#
# [*host_alias*]
#   Host_alias in sudoers. Accepts either a single string or an array. The
#   "namevar" will be the name of the alias.
#
# [*cmnd_alias*]
#   Cmnd_alias in sudoers. Accepts either a single string or an array. The
#   "namevar" will be the name of the alias.
#
# [*tag_spec*]
#   Tag specification (i.e. NOPASSWD). Does not accept arrays and assumes
#   you're only using a single specification at the moment.
#
#   TODO: Make this more flexible with arrays/hashes
#   
# [*option*]
#   Default sudoers options (i.e. Defaults env_keep). Accepts either a single
#   string or an array.
#
# [*user*]
#   User or Group used for the user specification. Defaults to the "namevar".
#
# [*command*]
#   Command(s) to pass to the user specification. Accepts either a single
#   string or an array.
#
# == Examples
#
#   sudo::entry {
#       "john":
#           tag_spec    => "NOPASSWD",
#           command     => "ALL";
#       "admin":
#           user        => "%admin",
#           host_alias  => "*.osuosl.org",
#           comment     => "Access for admins",
#           tag_spec    => "PASSWD",
#           cmnd_alias  => [ "/etc/init.d/apache2", "/bin/chown", "/bin/chmod",
#               "/usr/bin/less", ];
#       "env_keep":
#           option      => 'env_keep += "SSH_AUTH_SOCK"';
#   }
define sudo::entry (
    $ensure         = "present",
    $comment        = "",
    $user_alias     = "",
    $runas_alias    = "",
    $host_alias     = "",
    $cmnd_alias     = "",
    $tag_spec       = "",
    $option         = "",
    $user           = "$name",
    $command        = "") {

    # sudo skipping file names that contain a "."
    $alias_name = regsubst($name, '\.', '-', 'G')

    if $host_alias == "" {
        $host = "ALL"
    } else {
        $host = "$alias_name"
    }

    if $runas_alias == "" {
        $runas = "ALL"
    } else {
        $runas = "$alias_name"
    }

    if $cmnd_alias == "" {
        $cmd = $command
    } else {
        $cmd = "$alias_name"
    }
    sudo::conf { "${name}":
        ensure  => $ensure,
        content => template("sudo/sudoers.entry.erb"),
    }
}
