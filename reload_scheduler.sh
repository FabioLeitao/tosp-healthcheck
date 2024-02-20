#!/bin/bash
COMANDO=$0
ARGUMENTO=$1
TIMESTAMP=`date +"%Y-%m-%d %T"`
QUEM=`whoami`
QUAL=`hostname -s`

function reload_scheduler_(){
if [ ${QUEM} == "sc-tos-app" ] ; then
  echo "${TIMESTAMP} Error - Parando o Scheduler da Athenas no ${QUAL}" | tee -a ~/reload.log
  ssh leitao@localhost "sudo /usr/local/bin/stop_scheduler.sh"
  sleep 2
  echo "${TIMESTAMP} Iniciando o Scheduler da Athenas no ${QUAL}" | tee -a ~/reload.log
  ssh leitao@localhost "sudo /usr/local/bin/start_scheduler.sh"
  sleep 2
  ssh leitao@localhost "sudo /usr/local/bin/status_scheduler.sh"
  if [ ${TAIL} -eq "1" ] ; then
    ssh leitao@localhost "sudo /usr/bin/journalctl -f -u athenas-scheduler.service"
  fi
else
  echo "${TIMESTAMP} Error - Este comando deveria ser executado apenas pelo usuário sc-tos-app" | tee -a ~/reload.log ;
  exit 2 ;
fi
}

function arruma_param_(){
  case "${ARGUMENTO}" in
              -v|--verbose)
                         TAIL=1
                         echo "Server: ${QUAL}"
                         ;;
              *)
                         TAIL=0
                         echo "Server: ${QUAL}"
                         ;;
  esac
  reload_scheduler_;
}

function main_(){
  case "${ARGUMENTO}" in
        -h|--help)
                ajuda_;
                ;;
        *)
                arruma_param_;
                ;;
  esac
}

main_;
