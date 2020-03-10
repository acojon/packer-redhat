# Packer-Redhat

When making changes to kickstart.cfb, make sure the line endings are set to lf.

## Prerequisites

A few things are not included in the repository.  This was primarily to save space.  The repository will need the following items added to it:

* packer.exe
* A redhat iso, the code is written to look for: rhel-8.0-x86_64-dvd.iso
* share.yaml file

### share.yaml

When running Vagrant on HyperV, Vagrant will prompt at the command line for a username/password that can be used to setup smb shareJ(s).  These are used to synchronize the contents of a folder on the host, with a folder on the Vagrant box.  I created a share.yaml file and placed administrator credentials in the file.  The file is not committed to the repository, but you will need one of your own if you are going to use HyperV and do not want to be prompted for a username/password on every run.

Here is what the file looks like:

```yaml
username: UsernameGoesHere
password: PasswordForUserGoesHere
```

Save the file as share.yaml at the root of the repository, and you should be good to go :)

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
