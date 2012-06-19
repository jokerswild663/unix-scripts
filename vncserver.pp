#
#this will manage the vncserver settings
#
class environment::vncserver(
  $vncserver_source = "puppet://${server}/modules/environment/vncserver/vncserver"
) {
  case $osfamily {
    'Solaris': {
      $path = '/opt/csw/bin/vncserver'
      singleton_resources(Package['CSWvncs'])   
    }
    'Debian': {
      $path = '/usr/local/bin/vncserver'
      singleton_resources(Package['tightvncserver'])   
    }
    default: {
      fail("${operatingsystem} is not supported")
    }
  }

  file { $path:
    ensure => present,
    source => $vncserver_source,
    mode   => '0644',
  }
}
