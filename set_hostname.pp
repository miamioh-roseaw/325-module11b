$host_ip     = $facts['networking']['ip']
$linux_hosts = {
  '10.10.10.11' => 'ham-l',
  '10.10.10.12' => 'mid-l',
  '10.10.10.13' => 'oxf-l',
}
$windows_hosts = {
  '10.10.10.14' => 'mid-w',
  '10.10.10.15' => 'ham-w',
}

if $linux_hosts.has_key($host_ip) {
  $target_hostname = $linux_hosts[$host_ip]

  exec { "Set-Linux-Hostname":
    command   => "/usr/bin/hostnamectl set-hostname ${target_hostname}",
    path      => ['/usr/bin', '/bin'],
    logoutput => true,
    unless    => "/usr/bin/hostname | grep ${target_hostname}",
  }
} elsif $windows_hosts.has_key($host_ip) {
  $target_hostname = $windows_hosts[$host_ip]

  exec { "Rename-WindowsHostname":
    command   => "powershell.exe -Command \"Rename-Computer -NewName '${target_hostname}' -Force -Restart\"",
    provider  => powershell,
    logoutput => true,
    unless    => "powershell.exe -Command \"(hostname) -eq '${target_hostname}'\"",
  }
}
