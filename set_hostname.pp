$hostname_map = inline_template("<%= YAML.load_file('hostnames.yaml')['hosts'] %>")

$local_ip = inline_template('<%= Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address %>')

if $hostname_map[$local_ip] {
  $target_hostname = $hostname_map[$local_ip]

  notify { "Old hostname":
    message => inline_template('<%= `hostname` %>'),
  }

  exec { "Set hostname to ${target_hostname}":
    command => "hostnamectl set-hostname ${target_hostname}",
    path    => ['/bin', '/usr/bin'],
  }

  notify { "New hostname":
    message => inline_template('<%= `hostname` %>'),
  }
} else {
  fail("Unrecognized host IP: ${local_ip}")
}
