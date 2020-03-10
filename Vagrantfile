# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  if File.exist?("share.yaml")
    require 'yaml'
    share = YAML::load(File.open("share.yaml"))
  end

  config.vm.define "build" do |build|
    build.vm.box = "generic/debian10"
    build.vm.hostname = "build"

    build.vm.provider "hyperv" do |hv|
      hv.vmname = "build"
      hv.memory = "4098"
      hv.maxmemory = "4098"
      hv.cpus = "4"
      hv.enable_virtualization_extensions = true
      hv.linked_clone = true

      hv.vm_integration_services = {
        guest_service_interface: true
      }

      build.vm.synced_folder ".", "/vagrant", smb_username: share['username'], smb_password: share['password']
      build.vm.synced_folder "./ansible", "/home/vagrant/ansible", type: "smb", smb_username: share['username'], smb_password: share['password']
      build.vm.network "public_network", bridge: "Default Switch"
    end

    # Run the script to install ansible
    build.vm.provision "shell", path: "scripts/bootstrap.sh"

    build.vm.provision :host_shell do |host_shell|
      host_shell.inline = "powershell -c ./scripts/Copy_ISOToGuest.ps1"
    end

    build.vm.provision "shell", path: "scripts/ansible.sh", privileged: false

    build.vm.provision "shell", path: "ansible/files/make_iso.sh"
  end
end
