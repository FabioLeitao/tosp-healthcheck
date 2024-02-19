#!/bin/bash
COMANDO=$0
ARGUMENTO=$1
TIMESTAMP=`date +"%Y-%m-%d %T"`
P=`/usr/sbin/pidof java`
for pid_value in ${P};
  do
        V=`/usr/bin/sudo /usr/sbin/lsof -p ${pid_value} | wc -l`
        O=`echo ${TIMESTAMP} - ${V}`
        echo ${V}
        echo ${O} >> ~/open_files.log
  done
