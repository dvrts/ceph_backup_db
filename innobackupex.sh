#!/bin/bash
FILE="/usr/bin/xtrabackup"
VERSION=`lsb_release -c | awk '{ print $2}'`
if [ ! -f $FILE ]; then
        apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A; 
        echo "deb http://repo.percona.com/apt $VERSION main" >> /etc/apt/sources.list; 
        apt-get update;
        apt-get install xtrabackup -y
else 
        exit 0
fi
