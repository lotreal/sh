#!/bin/sh
#
# lvmMount.sh - Sample script to show mounting an LVM volume.
# Works in conjunction with createlvm.sh - run as superuser/sudo.
#

#Setup LD_LIBRARY_PATH to add fuse and vmware-vix-disklib/lib32
export LD_LIBRARY_PATH=............./libfuse-2.5.3/lib:......./vmware-vix-disklib

# First mount all the disks in flat mode.
vmware-mount -f disk0.vmdk /tmp/mnt/d0
vmware-mount -f disk1.vmdk /tmp/mnt/d1
# And setup loopback's.
losetup /dev/loop0 /tmp/mnt/d0/flat
losetup /dev/loop1 /tmp/mnt/d1/flat
# Let LVM scan for volume groups.
/usr/sbin/vgscan
# Activate the volume.
/usr/sbin/vgchange -a y vgrp0
# Let LVM scan for volumes.
/usr/sbin/lvscan
# Diagnostic print.
/usr/sbin/lvs
# Mount the volume.
mount /dev/vgrp0/vol0 lvmnt
# Compare the file to what we copied in createlvm.sh
if  diff lvmnt/test.txt gold.txt ; then
   echo "***** Passed test."
else
   echo "***** Failed test."
fi
# Prepare to exit. Unmount volume
umount lvmnt
# Deactivate the volume group.
/usr/sbin/vgchange -a n vgrp0
# Unassign the loopback's
losetup -d /dev/loop0
losetup -d /dev/loop1
# Unmount the vmdk's.
vmware-mount -d /tmp/mnt/d0
vmware-mount -d /tmp/mnt/d1
