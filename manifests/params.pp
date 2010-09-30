# Class: sudo::params
#
# Variables used in various sudo classes.
#
class sudo::params {

    $package_name = 'sudo'

    $package_version = $operatingsystem ? {
        'gentoo' => '1.7.4_p3-r1',

        'fedora' => $operatingsystemrelease ? {
            '13'      => '1.7.4p4-1.fc13',
            'default' => 'latest',
        },

        'centos' => $operatingsystemrelease ? {
            '5_5'     => '1.7.2p1-8.el5_5',
            'default' => 'latest',
        },
    }

}
