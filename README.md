# Packer-Redhat

When making changes to kickstart.cfb, make sure the line endings are set to lf.

## How To

There are three steps to this process:

1) Build a Debian vm using vagrant.  Use the vm to Build a RHEL iso file with the custom kickstart and boot settings.
1) Copy the RHEL iso from the Debian guest vm to the local host.
1) Use Packer to build a RHEL box from the custom iso.

### Build the Build Server and Create the ISO

The configured vagrant file will:

* Create a "Build" server, Debian 9
* Install Ansible (and the supporting software components)
* Copy the RHEL iso from the host to the Build server
* Run the ansible playbooks to:
  * Configure the build server
  * Copy the ISO into the appropriate folder
  * Copy the boot menu into the appropriate folder
  * Copy the Kickstart config into the appropriate folder
* Run the make_iso.sh script to build a rhel-ks.iso in the vagrant user's home folder on the Build server (Building the ISO over an samba share to the host shared folder takes too long)

```powershell
vagrant up
```

### Copy the ISO from the guest vm to the Host

Once this is complete, you need to copy the rhel-ks.iso from the build server back onto the host os.  I use WinSCP and logon as the vagrant user to copy the file.

### Run Packer to create the HyperV RHEL server, and RHEL Box

Run the powershell script

```powershell
powershell -c .\build.ps1
```

This script will:

* Delete the appropriate files
* Run packer to build the HyperV server and Vagrant Box
* Import the vagrant box.

## When Changing The kickstart iso

When regenerating the kickstart iso, be sure to delete the contents of the packer_cache.

run the playbook

```ssh
cd ansible

ansible-playbook -i production.yaml site.yaml
```
