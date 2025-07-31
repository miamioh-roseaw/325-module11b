# set_hostname.pp
require 'yaml'

$hostname_data = parseyaml(file('hostnames.yaml'))

$hostname_data.each |$fqdn, $hostname| {
  if $facts['os']['family'] == 'windows' {
    if $fqdn == $facts['networking']['fqdn'] {
      notify { "Setting Windows hostname to ${hostname}": }
      exec { "Rename-WindowsHostname":
        command   => "powershell.exe -Command \"Rename-Computer -NewName '${hostname}' -Force -Restart\"",
        provider  => powershell,
        logoutput => true,
        unless    => "powershell.exe -Command \"(hostname) -eq '${hostname}'\"",
      }
    }
  } elsif $facts['os']['family'] == 'Debian' or $facts['os']['family'] == 'RedHat' {
    if $fqdn == $facts['networking']['fqdn'] {
      notify { "Setting Linux hostname to ${hostname}": }
      exec { "Set-Linux-Hostname":
        command   => "/usr/bin/hostnamectl set-hostname ${hostname}",
        path      => ['/usr/bin', '/bin'],
        logoutput => true,
        unless    => "/usr/bin/hostname | grep ${hostname}",
      }
    }
  }
}
