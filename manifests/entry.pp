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
