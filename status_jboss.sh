#!/bin/sh
echo "Server: AZR-TOS-PRD-002"
echo "" 
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=1**.1**.**8.69:9990 --commands="read-attribute server-state" -u=adminTosp -p=T****1
echo "Server: AZR-TOS-PRD-003"
echo ""
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=1**.1**.**8.70:9990 --commands="read-attribute server-state" -u=adminTosp -p=T****1
echo "Server: AZR-TOS-PRD-004"
echo ""
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=1**.1**.**8.71:9990 --commands="read-attribute server-state" -u=adminTosp -p=T****1
echo "Server: AZR-TOS-PRD-005"
echo ""
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=1**.1**.**8.72:9990 --commands="read-attribute server-state" -u=adminTosp -p=T****1
echo ""
