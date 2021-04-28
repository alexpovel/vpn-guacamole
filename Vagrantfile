Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"

  # Using `libvirt`, was binding to localhost instead of all interfaces, hence
  # specify `host_ip` directly.
  # This enables public access.
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "0.0.0.0"

  config.vm.provision "file", source: "systemd/", destination: "/home/vagrant/"
  config.vm.provision "file", source: "docker/", destination: "/home/vagrant/"
  config.vm.provision "file", source: "vpn/.env", destination: "/home/vagrant/vpn.env"

  config.vm.provision "shell", path: "provision.sh"
  # I could for the life of me not get `openconnect` working to run in the background
  # reliably; it works fine as a systemd unit.
  config.vm.provision "shell", inline: <<-SHELL
    mv /home/vagrant/systemd/*.service /etc/systemd/system/ && \
    systemctl daemon-reload && \
    systemctl enable --now vpn.service guacamole.service
  SHELL
end
