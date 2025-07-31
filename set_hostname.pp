$hostname_map = loadyaml('hostnames.yaml')

$linux_hosts   = $hostname_map['linux']
$windows_hosts = $hostname_map['windows']

if $::osfamily == 'Debian' {
  $new_hostname = $linux_hosts[$::hostname]
  if $new_hostname {
    notify { "Setting Linux hostname to ${new_hostname}": }
    exec { 'set-linux-hostname':
      command => "/bin/hostnamectl set-hostname ${new_hostname}",
      unless  => "/bin/hostnamectl | grep -w '${new_hostname}'",
    }
  }
}

if $::osfamily == 'Windows' {
  $new_hostname = $windows_hosts[$::hostname]
  if $new_hostname {
    notify { "Setting Windows hostname to ${new_hostname}": }
    exec { 'set-windows-hostname':
      command => "powershell.exe -Command \"Rename-Computer -NewName '${new_hostname}' -Force -Restart\"",
      unless  => "powershell.exe -Command \"\$env:COMPUTERNAME -eq '${new_hostname}'\"",
    }
  }
}
