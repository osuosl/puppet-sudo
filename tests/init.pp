include sudo

sudo::sudoer {"%wheel":}
sudo::sudoer {"mike": users => 'apache', password => false,}
sudo::sudoer {"bob": users => ["mike","fred"], commands => ['/usr/bin/apt-get', '/etc/init.d/apache'] }
