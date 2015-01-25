#!/bin/bash
ENV=`cat "/usr/local/etc/env"`
RBD_DEVICE=`rbd showmapped | grep $ENV | awk '{ print $5 }'`
TIME=$(date +%d-%m-%Y -d "1 day ago")
SLEEP=$((($RANDOM % 10) + 1))
FILE=lock.file
MOUNTPATH=/mnt/ceph/ #or any you wish

if mount | grep /dev/rbd > /dev/null; then
        echo "RBD device is already mounted"
else
       mkdir $MOUNTPATH; mount $RBD_DEVICE $MOUNTPATH
fi

if mount | grep /dev/rbd > /dev/null; then
        sleep $SLEEP
else
        echo "Please, check mount status of RBD device"
fi

if [ ! -f ${MOUNTPATH}/${FILE} ]
then
        touch ${MOUNTPATH}/${FILE}
else
        exit 0
fi

rm ${MOUNTPATH}${TIME}*.tar.gz
rm ${MOUNTPATH}/${FILE}

umount "$RBD_DEVICE"; rmdir "$MOUNTPATH"

if mount | grep /dev/rbd > /dev/null; then
        umount "$RBD_DEVICE"; rmdir "$MOUNTPATH"
else
        exit 0
fi
