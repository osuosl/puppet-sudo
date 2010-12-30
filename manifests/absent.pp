#Class: sudo::absent
#
# Removes the sudo package
#
#Usage:
#include sudo::absent
class sudo::absent inherits sudo {

  Package['sudo'] { ensure => absent, }
