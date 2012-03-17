# Class: sudo::standard
#
# Sets up a fairly normal set of sudo rules.
#
# Usage:
#   # 'include sudo' is not needed
#   include sudo::standard
#
class sudo::standard inherits sudo {
    # Also sets up all the packages and files for sudo.

    # Enable environemnt resets.
    sudo::default { 'env_reset':
        option => 'env_reset',
    }

    # Give root and %wheel sudo access.
    sudo::sudoer {
        'root':;
        '%wheel':;
    }
}
