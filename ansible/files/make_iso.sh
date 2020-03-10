cd /root/rhel-install

genisoimage -J -T -o /home/vagrant/rhel-ks.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -m TRANS.TBL -graft-points -V "RHEL-8-0-0-BaseOS-x86_64" /root/rhel-install/

chown vagrant:vagrant /home/vagrant/rhel-ks.iso
