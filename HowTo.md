# RHEL-BOX

To keep track of the things needed to create a new RHEL Vagrant Box :)

## The Mostly Automated process - Much easier

If you just need a fresh build of the box, here is the method.  It's not 100% automated, but it's as automated as I can make it (for now)

* Open a PowerShell window as Administrator in the root of the Repository.

```powershell
vagrant up
```

* When the build is finished, connect to the box as the vagrant user, and use WinSCP to copy the rhel-ks.iso from the vagrant box to the root of the repository; i.e., the current folder on the host.  __No example given for this step.__

* Run the PowerShell build script

```powershell
build.ps1.\
```

* When the process finishes, you will have:
  * rhel8-hyperv.box in the root of the repository
  * The box will be imported into vagrant on the local machine

* That's it, process complete :)

## The Manual Process

If you need to walk through the steps by hand, here is what the process is doing.

### Build an unattended install for RHEL

RHEL calls the software Kickstarter.  When you build a new installation, an anaconda-ks.cfg file is created in the root directory.  This contains all of the settings that were picked when installing the OS on a new computer.

#### Install RHEL on a new VM

This generates the anaconda file, but it also gives you a place to run all of the other subsequent steps needed for the installation.  I took these steps from RedHat's pages on how to build an unattended install.

* 50gb disk.  This is for all the files
* 4 cpu to speed things up
* 4GB of ram to speed things up
* Install all of the software available, unless you figure out which module has the mkisofs and isoinfo commands ;)

#### Build the unattended ISO

Install genisoimage to get isoinfo

```bash
apt-get install genisoimage
```

Log onto the RHEL server you built.

Copy the RedHat installation iso to the /root folder on the server.

Mount the iso

```bash
mount -o loop ./rhel-8.0-x86_64-dvd.iso /mnt/
```

Create a working diresctory and copy the DVD contents into it

```bash
mkdir /root/rhel-install/
shopt -s dotglob
cp -avRf /mnt/* /root/rhel-install/
```

Unmount the iso

```bash
umount /mnt/
```

Copy the kickstart file

```bash
cp /vagrant/unattended/kickstart.cfg /root/rhel-install/
```

Display the installation DVD volume name.  Some of the volume names RHEL used have a space, and those need to be escaped.  This should help find out.

```bash
isoinfo -d -i rhel-server-7.5-x86_64-dvd.iso | grep "Volume id" | sed -e 's/Volume id: //' -e 's/ /\\x20/g'

# Prints out the name with the space escaped
RHEL-7.5\x20Server.x86_64
```

Edit the boot menu / Copy over the edited one I made

```bash
cp /vagrant/unattended/isolinux.cfg /root/rhel-install/
```

Create the rhel-ks.iso

```bash
genisoimage -J -T -o /root/rhel-ks.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -m TRANS.TBL -graft-points -V "RHEL-8-0-0-BaseOS-x86_64" /root/rhel-install/
```

Copy the rhel-ks.iso off the server using SCP.

I recommend that you try building a new vm from the iso to check it.  You can run the Test_NewISO.ps1 script to help with this process.

```powershell
.\Test_NewISO.ps1
```
