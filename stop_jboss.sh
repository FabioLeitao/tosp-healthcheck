#!/bin/sh
nohup /home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=1**.1**.**8.70:9990 command=:shutdown -u=adminTosp -p=T****1 & > /dev/null
