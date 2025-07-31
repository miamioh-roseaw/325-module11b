exec { 'set_hostname':
  command => inline_template("<%
    require 'yaml'
    require 'socket'

    # Load YAML file
    file = YAML.load_file('/var/lib/jenkins/workspace/puppet_hostnames/hostnames.yaml')
    host_map = file['hosts']

    # Get the local IP
    ip = Socket.ip_address_list.detect(&:ipv4_private?).ip_address

    # Print old hostname
    old_name = `hostname`.strip
    puts \"[OLD] Hostname: #{old_name}\"

    # Lookup new hostname
    new_name = host_map[ip]
    raise \"Unrecognized IP #{ip}\" unless new_name

    # Set the new hostname
    system(\"hostnamectl set-hostname #{new_name}\")

    # Print new hostname
    puts \"[NEW] Hostname: #{new_name}\"
  %>"),
  path    => ['/bin', '/usr/bin'],
}
