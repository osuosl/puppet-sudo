include sudo

# Give the group 'wheel' full access to password protected sudo the hard way.
sudo::sudoers_line{"wheel-manual":
    line => "%wheel ALL=(ALL) ALL",
}

# Give the group 'wheel' full access to password protected sudo the easy way.
sudo::sudoer {"%wheel":}

# Give the user 'mike' access to impersonate only 'apache' without a password
sudo::sudoer {"mike":
    users => "apache",
    password => false,
}

sudo::default { 'env_reset':
    option => 'env_reset',
}

sudo::default { 'wheel_env':
    option  => '!env_reset',
    sudoers => '%wheel',
}

sudo::default { 'admins':
    option => ['timestamp_timeout=10', '!tty_tickets'],
    sudoers => ['bob', 'fred', 'alice'],
}
