include sudo

sudo::sudoer {'%wheel':}
sudo::sudoer {'mike': users => 'apache', password => false,}
sudo::sudoer {'bob': users => ['mike','fred'], commands => ['/usr/bin/apt-get', '/etc/init.d/apache'],}

sudo::default {'env_reset': option => 'env_reset',}
sudo::default {'env_wheel': sudoers => "%wheel", option => '!env_reset',}
