$host_ip = $facts['networking']['ip']

case $host_ip {
  '10.10.10.10': { $target_hostname = 'jenkins-server' }
  '10.10.10.11': { $target_hostname = 'ham-linux' }
  '10.10.10.12': { $target_hostname = 'mid-linux' }
  '10.10.10.13': { $target_hostname = 'oxf-linux' }
  '10.10.10.14': { $target_hostname = 'mid-win' }
  '10.10.10.15': { $target_hostname = 'ham-win' }
  default: { fail("Unrecognized host IP: ${host_ip}") }
}

if $facts['os']['family'] == 'windows' {
  # Print current hostname
  exec { 'Print-Windows-Hostname-Before':
    command   => 'powershell.exe -Command "Write-Output \"Current Hostname: $(hostname)\""',
    provider  => powershell,
    logoutput => true,
  }

  # Rename Windows machine
  exec { "Rename-WindowsHostname":
    command   => "powershell.exe -Command \"Rename-Computer -NewName '${target_hostname}' -Force -Restart\"",
    provider  => powershell,
    logoutput => true,
    unless    => "powershell.exe -Command \"(hostname) -eq '${target_hostname}'\"",
    require   => Exec['Print-Windows-Hostname-Before'],
  }

  # This won’t run after restart, but it's here for completeness
  exec { 'Print-Windows-Hostname-After':
    command   => 'powershell.exe -Command "Write-Output \"New Hostname: $(hostname)\""',
    provider  => powershell,
    logoutput => true,
    onlyif    => "powershell.exe -Command \"(hostname) -eq '${target_hostname}'\"",
  }

} else {
  # Print current Linux hostname
  exec { 'Print-Linux-Hostname-Before':
    command   => '/bin/echo "Current Hostname: $(hostname)"',
    logoutput => true,
  }

  # Set Linux hostname
  exec { "Set-Linux-Hostname":
    command   => "/usr/bin/hostnamectl set-hostname ${target_hostname}",
    path      => ['/usr/bin', '/bin'],
    logoutput => true,
    unless    => "/bin/hostname | grep ${target_hostname}",
    require   => Exec['Print-Linux-Hostname-Before'],
  }

  # Print new hostname
  exec { 'Print-Linux-Hostname-After':
    command   => '/bin/echo "New Hostname: $(hostname)"',
    logoutput => true,
    onlyif    => "/bin/hostname | grep ${target_hostname}",
  }
}
