#!/bin/sh
nohup /home/sc-tos-app/appServer_TOSP/bin/standalone.sh --server-config=standalone-tosp.xml -Djboss.bind.address=10.129.48.70 -Djboss.bind.address.management=10.129.48.70 -Djboss.socket.binding.port-offset=0 -b 10.129.48.70 & >/dev/null
