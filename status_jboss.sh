#!/bin/sh
echo "Server: AZR-TOS-PRD-002"
echo "" 
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=10.129.48.69:9990 --commands="read-attribute server-state" -u=adminTosp -p=Tosp@2021
echo "Server: AZR-TOS-PRD-003"
echo ""
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=10.129.48.70:9990 --commands="read-attribute server-state" -u=adminTosp -p=Tosp@2021
echo "Server: AZR-TOS-PRD-004"
echo ""
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=10.129.48.71:9990 --commands="read-attribute server-state" -u=adminTosp -p=Tosp@2021
echo "Server: AZR-TOS-PRD-005"
echo ""
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=10.129.48.72:9990 --commands="read-attribute server-state" -u=adminTosp -p=Tosp@2021
echo ""
