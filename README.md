# Remote desktop access through VPN

This project sets up an [Apache Guacamole](https://guacamole.apache.org/) server.
It allows to access RDP, VNC etc. resources to be accessed *in a client browser*.

## Rationale

In my use case, the machine to RDP to sits inside a VPN.
The process of connecting to it is annoying:

1. On some machine, e.g. a Windows desktop, enable VPN.
    The entire machine is now inside that VPN, even if it's only required for RDP.
2. Open RDP and connect to the machine.
3. If you need to turn off VPN for some reason, your RDP session will collapse.

Guacamole, through that VPN, allows this to simply be:

1. Open browser, navigate to the Guacamole service, use RDP.
2. Close browser tab whenever, VPN/RDP etc. keeps running.

The fact that VPN is needed to make this happen is entirely opaque.

## Usage

Example is for Debian 10.
Install dependencies on the host ([KVM](https://wiki.debian.org/KVM#Installation)):

```bash
apt install vagrant qemu-system libvirt-clients libvirt-daemon-system
```

HashiCorp/Vagrant themselves recommend [not using a distro package manager to install Vagrant](https://www.vagrantup.com/docs/installation), but I've had no issues.

Then simply start the VM, the services inside launch automatically (VPN and guacamole server):

```bash
vagrant up
```

After Vagrant reports success, it still takes a couple minutes for everything to be up because docker-compose build and pulls images *inside* the machine (Vagrant can't know that from the outside).

Access the service from another machine (or the same) at <http://servername:8080/guacamole/>.
Login with `guacadmin/guacadmin`.
Note a couple things:

1. Change the default admin credentials immediately.
2. Your instance is **publically accessible** (bound on `0.0.0.0`), aka it's only a firewall port forwarding rule in your router/firewall away from being public on the internet. This is however needed to have the service reachable by other machines on your local network.
3. The Docker volumes help the service be persistent across container restarts, but those live *inside the VM*. If you destroy that VM, your guacamole server is destroyed.

## Ugliness

All this *almost* works using pure docker-compose, but it ultimately failed with
[this exact issue](https://github.com/dperson/openvpn-client/issues/210).
Hence, to embed the entire guacamole stack inside/behind a VPN, we unfortunately need to bring out the big guns.
Vagrant provisions a simple but proper VM in which VPN is activated globally.
If you're fine with activating a VPN on bare-metal, skip the entire Vagrant step.
In my case, many other services were running on the same machine destined to run guacamole, so enabling that VPN system-wide was not an option.

Inside Vagrant, we simply bring up the docker-compose stack.
Once, if ever, `--network-mode=container:vpn`, see the above link, works, we can scrap Vagrant/VMs entirely again.
That's also the reason we run Docker inside a VM, instead of doing all the Docker-related stuff on the VM directly.
That would also be pretty easy using Vagrant, but the guacamole stack wouldn't be nicely separated.

As it stands now, you can simply extract the entire [docker](docker/) directory and run it by itself, if you don't need a VPN.
The advantage of that is that the stack contains a guacamole-server with RDP support, something the [official image](https://hub.docker.com/r/guacamole/guacd) does not have for some reason (it needs to be compiled from source).
