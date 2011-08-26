class sudo ($ensure = "latest") {
    package { "sudo":
        ensure => $ensure,
    }

    file {
        "/etc/sudoers":
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => 440,
            source  => "puppet:///modules/sudo/sudoers";
        "/etc/sudoers.d":
            ensure  => directory,
            owner   => root,
            group   => root,
            mode    => 750;
    }
}
