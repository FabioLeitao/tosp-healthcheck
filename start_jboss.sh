#!/bin/sh
nohup /home/sc-tos-app/appServer_TOSP/bin/standalone.sh --server-config=standalone-tosp.xml -Djboss.bind.address=1**.1**.**8.70 -Djboss.bind.address.management=1**.1**.**8.70 -Djboss.socket.binding.port-offset=0 -b 1**.1**.**8.70 & >/dev/null
