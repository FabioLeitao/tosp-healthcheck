#!/bin/sh
COMANDO=$0
ARGUMENTO=$1

function ajuda_(){
        echo "Usage: $COMANDO [servidor] [-h|--help]" >&2 ;
}

function flush_pool_(){
echo FLUSH IDLE
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${IP}:9990 --commands="/subsystem=datasources/data-source=tosdev/:flush-idle-connection-in-pool" -u=adminTosp -p=T****1
echo FLUSH INVALID
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${IP}:9990 --commands="/subsystem=datasources/data-source=tosdev/:flush-invalid-connection-in-pool" -u=adminTosp -p=T****1
echo FLUSH GRACEFULLY
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${IP}:9990 --commands="/subsystem=datasources/data-source=tosdev/:flush-gracefully-connection-in-pool" -u=adminTosp -p=T****1
echo FLUSH ALL
/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${IP}:9990 --commands="/subsystem=datasources/data-source=tosdev/:flush-all-connection-in-pool" -u=adminTosp -p=T****1
}

function arruma_param_(){
    case "${ARGUMENTO}" in
              002)
                         IP=10.129.48.70;
			 echo "Server Server: AZR-TOS-PRD-002"
    			 flush_pool_;
                         ;;
              003)
                         IP=10.129.48.71;
			 echo "Server Server: AZR-TOS-PRD-003"
    			 flush_pool_;
                         ;;
              004)
                         IP=10.129.48.69;
			 echo "Server Server: AZR-TOS-PRD-004"
    			 flush_pool_;
                         ;;
              005)
                         IP=10.129.48.72;
			 echo "Server Server: AZR-TOS-PRD-005"
    			 flush_pool_;
                         ;;
              dev|DEV)
                         IP=10.129.44.68;
			 echo "Server Server: AZR-TOS-DEV"
    			 flush_pool_;
                         ;;
	      qa|QA)
                         IP=10.129.44.196;
			 echo "Server Server: AZR-TOS-QA"
    			 flush_pool_;
                         ;;
              *)
			 ajuda_;
                         ;;
    esac
}

case "${ARGUMENTO}" in
        -h|--help)
                ajuda_;
                ;;
        *)
                arruma_param_;
                ;;
esac
