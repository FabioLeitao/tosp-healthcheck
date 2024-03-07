#!/bin/bash 
COMANDO=$0
ARGUMENTO=$1
TIMESTAMP=`date +"%Y-%m-%d %T"`
QUEM=`whoami`
QUAL=`hostname -s`
IPCLI="/usr/sbin/ip"
GREPCLI="/usr/bin/grep"
AWKCLI="/usr/bin/awk"
SELFIP=`${IPCLI} ad | ${GREPCLI} -A 2 UP | ${GREPCLI} eth0 | ${GREPCLI} inet | ${AWKCLI} -F"/" '{printf $1}' | ${AWKCLI} '{printf $2}'`

function ajuda_(){
        echo "Usage: $COMANDO [-v|--verbose] [-h|--help]" >&2 ;
}

function reinicia_jboss_(){
  if [ ${QUEM} == "sc-tos-app" ] ; then
	if [ ${QUAL} == "azr-tos-qa" ] || [ ${QUAL} == "azr-tos-dev" ] || [ ${QUAL} == "azr-tos-prd-002" ]; then
                echo "${TIMESTAMP} Error - Parando o Scheduler da Athenas no ${QUAL}" | tee -a ~/reload.log
                ssh leitao@localhost "sudo /usr/local/bin/stop_scheduler.sh"
        fi
	echo "${TIMESTAMP} Error - Parando o JBOSS para reload simples no ${QUAL}" | tee -a ~/reload.log
	cd ~/appServer_TOSP/ ; 
	~/appServer_TOSP/stop_jboss.sh
	ULTIMA=$?
	sleep 6
	QUANTOS=`ps aux | grep java | grep -i Stand | wc -l`
	if [ ${ULTIMA} -ne 0 ] || [ ${QUANTOS} -gt 0 ]  ; then
		/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${SELFIP}:9990 command=:shutdown -u=adminTosp -p=Tosp@2021
		ULTIMA=$?
		sleep 3
	fi
	QUANTOS=`ps aux | grep java | grep -i Stand | wc -l`
	if [ ${ULTIMA} -ne 0 ] || [ ${QUANTOS} -gt 0 ]  ; then
		#kill -9 `pidof java` ; 
		kill -9 `ps aux | grep java | grep -i stand | awk '{printf $2}'` ; 
		sleep 3
	fi
	cd standalone/tmp ; 
	rm -rf * ; 
	cd ../deployments ; 
	rm *.deployed ; 
	rm *.undeploy* ; 
	cd ../.. ; 
	sleep 3 ; 
	./start_jboss.sh ; 
	cd ;
	echo "${TIMESTAMP} - Aguardando iniciar o JBOSS no ${QUAL}" | tee -a ~/reload.log
	sleep 8 ; 
	if [ ${QUAL} == "azr-tos-prd-002" ]; then
                sleep 20
		echo "${TIMESTAMP} - Iniciando o Scheduler da Athenas no ${QUAL}" | tee -a ~/reload.log
		ssh leitao@localhost "sudo /usr/local/bin/start_scheduler.sh"
	fi
	if [ ${TAIL} -eq "1" ] ; then
		lnav ~/appServer_TOSP/nohup.out ;
	fi
	exit 0 ;
  else
	echo "${TIMESTAMP} Error - Este comando deveria ser executado apenas pelo usuário sc-tos-app" | tee -a ~/reload.log ;
	exit 2 ;
  fi
}

function arruma_param_(){
  case "${ARGUMENTO}" in
              -v|--verbose)
                         TAIL=1
			 echo "Server Server: ${QUAL}"
                         ;;
              *)
                         TAIL=0
			 echo "Server Server: ${QUAL}"
                         ;;
  esac
  reinicia_jboss_;
}

case "${ARGUMENTO}" in
        -h|--help)
                ajuda_;
                ;;
        *)
                arruma_param_;
                ;;
esac
