$host_ip = $facts['networking']['ip']

case $host_ip {
  '10.10.10.11': { $target_hostname = 'ham-l' }
  '10.10.10.12': { $target_hostname = 'mid-l' }
  '10.10.10.13': { $target_hostname = 'oxf-l' }
  '10.10.10.14': { $target_hostname = 'mid-w' }
  '10.10.10.15': { $target_hostname = 'ham-w' }
  default: { fail("Unrecognized host IP: ${host_ip}") }
}

# Determine OS and execute the appropriate command
if $facts['os']['family'] == 'windows' {
  exec { "Rename-WindowsHostname":
    command   => "powershell.exe -Command \"Rename-Computer -NewName '${target_hostname}' -Force -Restart\"",
    provider  => powershell,
    logoutput => true,
    unless    => "powershell.exe -Command \"(hostname) -eq '${target_hostname}'\"",
  }
} else {
  exec { "Set-Linux-Hostname":
    command   => "/usr/bin/hostnamectl set-hostname ${target_hostname}",
    path      => ['/usr/bin', '/bin'],
    logoutput => true,
    unless    => "/usr/bin/hostname | grep ${target_hostname}",
  }
}
