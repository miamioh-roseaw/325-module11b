class hostname_setter (
  String $desired_hostname
) {

  exec { "set_hostname":
    command => "/bin/hostnamectl set-hostname ${desired_hostname}",
    path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
    unless  => "hostname | grep -q ${desired_hostname}",
  }
}
