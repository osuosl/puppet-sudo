define sudo::file (
    $ensure     = "present",
    $content    = "",
    $source     = "") {

    file { "/etc/sudoers.d/${name}":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => 440,
        content => $content ? {
            ""      => undef,
            default => $content,
        },
        source  => $source ? {
            ""      => undef,
            default => $source,
        },
        notify  => Exec["sudo-syntax-check $name"],
        require => [ Package["sudo"], File["/etc/sudoers.d"], ],
    }

    exec { "sudo-syntax-check $name":
        command     => "visudo -c -f /etc/sudoers.d/${name} || ( rm -f /etc/sudoers.d/${name} && exit 1)",
        refreshonly => true,
    }
}
