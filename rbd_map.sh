#!/bin/bash
#RBD_DEVICE=`rbd showmapped | grep /dev/rbd | awk '{ print $5 }'`
RBD_DEVICE="/dev/rbd1"
POOL="backups"
IMAGE="mysql-prod"
MOUNTPATH=/mnt/ceph-block-device/ #or any you wish

# map rbd device
rbd map $IMAGE --pool $POOL

# check is $POOL successfully mapped
if rbd showmapped | grep $POOL > /dev/null; then
        echo "$POOL is already mapped" 
else
        echo "$POOL device is unmapped, please check it"; exit 0
fi

# check is $IMAGE successfully mapped
if rbd showmapped | grep $IMAGE > /dev/null; then
        echo "$IMAGE is already mapped" 
else
        echo "$IMAGE device is unmapped, please check it"; exit 0
fi

# create filesystem on rbd device
mkfs.ext4 -m0 $RBD_DEVICE

if mount | grep $RBD_DEVICE > /dev/null; then
        echo "RBD device is already mounted"
else
       mkdir $MOUNTPATH; mount $RBD_DEVICE $MOUNTPATH
fi

umount $RBD_DEVICE
# rbd unmap $RBD_DEVICE
