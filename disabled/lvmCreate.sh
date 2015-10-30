#!/bin/sh
#
# LvmCreate.sh - Sample script to create an LVM volume from two VMDK's.
#
#Setup LD_LIBRARY_PATH to add fuse and vmware-vix-disklib/lib32
export LD_LIBRARY_PATH=............./libfuse-2.5.3/lib:......./vmware-vix-disklib/lib32:${LD_LIBRARY_PATH}
# Clean up existing disks.
rm disk0.vmdk
rm disk1.vmdk
# Create 2 new disks.
vmware-vdiskmanager -c -s 850MB -a ide -t 0 disk0.vmdk
vmware-vdiskmanager -c -s 850MB -a ide -t 0 disk1.vmdk
# Create mount points.
mkdir -p /tmp/mnt/d0
mkdir -p /tmp/mnt/d1
# Mount each disk in flat mode.
vmware-mount -f disk0.vmdk /tmp/mnt/d0
vmware-mount -f disk1.vmdk /tmp/mnt/d1
# Setup loopback's.
losetup /dev/loop0 /tmp/mnt/d0/flat
losetup /dev/loop1 /tmp/mnt/d1/flat
# Now setup LVM physical groups and volume groups.
/usr/sbin/pvcreate /dev/loop0 /dev/loop1
/usr/sbin/vgcreate vgrp0 /dev/loop0 /dev/loop1
# And create an LVM logical group.
/usr/sbin/lvcreate --name vol0  --size 1.2G vgrp0
/usr/sbin/lvscan
mkdir lvmnt
# Format.
mke2fs /dev/vgrp0/vol0
# Finally mount the LVM volume and copy a test file.
mount /dev/vgrp0/vol0 lvmnt
cp gold.txt lvmnt/test.txt
# Prepare to exit, unmount, deactivate the volume
umount lvmnt
/usr/sbin/vgchange -a n vgrp0
# Free up the loopback devices.
losetup -d /dev/loop0
losetup -d /dev/loop1
# And finally unmount the disks.
vmware-mount -d /tmp/mnt/d0
vmware-mount -d /tmp/mnt/d1
#
# Now we have a couple of VMDK's implelemening an LVM volume.
# See mountlvm.sh to remount the above and test.
