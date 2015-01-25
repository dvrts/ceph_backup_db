!/bin/bash
# Requirements:
# Ubuntu 12.04 or above;
# Innobackupex (additional info is here http://www.percona.com/doc/percona-xtrabackup/2.1/installation/apt_repo.html)
# Existing Ceph storage (more info here http://ceph.com/docs/master/start/quick-rbd/)
ENV=`cat "/usr/local/etc/env"`
TIME=$(date +"%d-%m-%Y")
SLEEP=$((($RANDOM % 10) + 1))
FILE=lock.file
MOUNTPATH=/mnt/ceph/ #or any you wish
RBD_DEVICE="/dev/rbd/backups/mysql-test"

if mount | grep /dev/rbd > /dev/null; then
        echo "RBD device is already mounted"
else
       mkdir "$MOUNTPATH"; mount "$RBD_DEVICE" "$MOUNTPATH"
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

innobackupex --stream=tar $MOUNTPATH | gzip - > "$MOUNTPATH"/Daily-"$TIME".tar.gz

rm ${MOUNTPATH}/${FILE}
umount "$RBD_DEVICE"; rmdir "$MOUNTPATH"

if mount | grep /dev/rbd > /dev/null; then
        umount "$RBD_DEVICE"; rmdir "$MOUNTPATH"
else
        exit 0
fi
