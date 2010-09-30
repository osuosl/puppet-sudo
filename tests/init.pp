include sudo
sudo::sudoers_line { "01_wheel":
    line => "%wheel  ALL=(ALL)   ALL",
}
