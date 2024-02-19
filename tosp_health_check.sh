#!/bin/sh
COMANDO=$0
ARGUMENTO=$1
TIMESTAMP=`date +"%Y-%m-%d %T"`
CONTADOR=0

function ajuda_(){
        echo "Usage: $COMANDO [servidor] [-h|--help]" >&2 ;
}

function reload_jboss(){
  /home/sc-tos-app/appServer_TOSP/.reload_simples_jboss.sh
  sleep 30
  conta_memoria_;
}

function confere_sgad_(){
CONTEUDO=`/usr/local/bin/rust-healthcheck-and-reconnect-sgad A****8 | grep -i "681 SGAD_ATIVO TRUE"`
ULTIMA=$?
TIMESTAMP=`date +"%Y-%m-%d %T"`
if [ ${ULTIMA} -ne 0 ] ; then
  echo "${TIMESTAMP} Error - SGAD desconectado pelo cosetting" | tee -a ~/sgad_ativo.log
  sleep 1
  CONTADOR=`expr ${CONTADOR} + 1`
  if [ ${CONTADOR} -lt 5 ]; then
  	TIMESTAMP=`date +"%Y-%m-%d %T"`
  	confere_sgad_;
  else
  	TIMESTAMP=`date +"%Y-%m-%d %T"`
  fi
else
  echo "${TIMESTAMP} - SGAD conectado pelo cosetting" | tee -a ~/sgad_ativo.log
fi
}

function chama_url_(){
CONTEUDO=`curl -L -X GET http://${IP}:8080/tosp | grep "Not Found"`
ULTIMA=$?
TIMESTAMP=`date +"%Y-%m-%d %T"`
if [ ${ULTIMA} -ne 0 ] ; then
  echo "${TIMESTAMP} - SITE TOSP respondendo" | tee -a ~/disponibilidade.log
else
  echo "${TIMESTAMP} Error - SITE TOSP indisponivel" | tee -a ~/disponibilidade.log
      reload_jboss;
fi
}

function conta_openfiles_(){
OPEN=`ssh leitao@localhost /home/leitao/conta_openfiles.sh`
ULTIMA=$?
TIMESTAMP=`date +"%Y-%m-%d %T"`
if [ ${ULTIMA} -ne 0 ] ; then
  echo ${TIMESTAMP} Error - ERRO AO CONTAR OPENFILES | tee -a ~/openfiles.log
else
  for open_value in ${OPEN};
  do
    echo ${TIMESTAMP} - OPENFILES ${open_value} | tee -a ~/openfiles.log
    if [ ${open_value} -gt 10000 ] ; then
      reload_jboss;
    fi
  done
fi
}

function conta_pool_(){
DISPONIVEL=`/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${IP}:9990 --commands="/subsystem=datasources/data-source=tosp/statistics=pool:read-resource(include-runtime=true)" -u=adminTosp -p=Tosp@2021 | grep -i available | awk -F" " {'printf $3'} | awk -F"," {'printf $1'} `
ULTIMA=$?
TIMESTAMP=`date +"%Y-%m-%d %T"`
if [ ${ULTIMA} -ne 0 ] ; then
 echo ${TIMESTAMP} Error - ERRO AO CONTAR TAMANHO DO POOL | tee -a ~/tamanho.log
 reload_jboss;
else
 echo ${TIMESTAMP} - POOL DISPONIVEL ${DISPONIVEL} | tee -a ~/tamanho.log
 if [ ${DISPONIVEL} -lt 250 ] ; then
    source ~/appServer_TOSP/flush_jboss_pool.sh $ARGUMENTO
    echo ${TIMESTAMP} Error - FLUSH NO POOL EXECUTADO | tee -a ~/tamanho.log
 fi
 if [ ${DISPONIVEL} == "connect" ] || [  ${DISPONIVEL} == "" ] ; then
    reload_jboss;
 fi
fi
}

function valida_jboss_(){
DISPONIVEL=`/home/sc-tos-app/appServer_TOSP/bin/jboss-cli.sh --connect --controller=${IP}:9990 --commands="read-attribute server-state" -u=adminTosp -p=Tosp@2021`
ULTIMA=$?
TIMESTAMP=`date +"%Y-%m-%d %T"`
if [ ${ULTIMA} -ne 0 ] ; then
 echo ${TIMESTAMP} Error - ERRO AO CONECTAR NO JBOSS CLI | tee -a ~/jboss_cli.log
 reload_jboss;
else
 if [ ${DISPONIVEL} == "running" ] ; then
    echo ${TIMESTAMP} - JBOSS CLI OPERANDO NORMALMENTE | tee -a ~/jboss_cli.log
 else
    echo ${TIMESTAMP} Error - JBOSS CLI OPERANDO TRAVADO OU INDISPONIVEL | tee -a ~/jboss_cli.log
    reload_jboss;
 fi
fi
}

function conta_memoria_(){
        # Define o nome do processo JBoss
        JBOSS_PROCESS="Standalone"

        # Obtém o ID do processo JBoss
        JBOSS_PID=$(ps -ef | grep "$JBOSS_PROCESS" | grep -v "grep" | awk '{print $2}')

        TIMESTAMP=`date +"%Y-%m-%d %T"`
        
        # Verifica se o processo JBoss está em execução
        if [ -z "$JBOSS_PID" ]; then
          MEMO=`free -mlt | grep Mem | awk -F" " '{print "Memoria Usada: "$3" Livre: "$4}' `
          echo ${TIMESTAMP} Error - ${MEMO} JBoss não está em execução | tee -a ~/memoria.log
        else
          # Obtém o uso de memória do processo JBoss
          JBOSS_MEMORY=$(ps -p $JBOSS_PID -o %mem | awk 'NR>1')

          # Exibe o uso de memória do JBoss
          MEMO=`free -mlt | grep Mem | awk -F" " '{print "Memoria Usada: "$3" Livre: "$4}' `
          echo ${TIMESTAMP} - ${MEMO} Jboss: ${JBOSS_MEMORY}% | tee -a ~/memoria.log
        fi
}

function arruma_param_(){
    case "${ARGUMENTO}" in
              002)
                         IP=10.129.48.70;
			 echo "Server Server: AZR-TOS-PRD-002"
			 conta_memoria_;
			 valida_jboss_;
    			 conta_pool_;
                         conta_openfiles_;
			 chama_url_;
			 #confere_sgad_;
                         ;;
              003)
                         IP=10.129.48.71;
			 echo "Server Server: AZR-TOS-PRD-003"
			 conta_memoria_;
			 valida_jboss_;
    			 conta_pool_;
                         conta_openfiles_;
			 chama_url_;
                         ;;
              004)
                         IP=10.129.48.69;
			 echo "Server Server: AZR-TOS-PRD-004"
			 conta_memoria_;
			 valida_jboss_;
    			 conta_pool_;
                         conta_openfiles_;
			 chama_url_;
                         ;;
              005)
                         IP=10.129.48.72;
			 echo "Server Server: AZR-TOS-PRD-005"
			 conta_memoria_;
			 valida_jboss_;
    			 conta_pool_;
                         conta_openfiles_;
			 chama_url_;
                         ;;
              dev|DEV)
                         IP=10.129.44.68;
			 echo "Server Server: AZR-TOS-DEV"
			 conta_memoria_;
			 valida_jboss_;
    			 conta_pool_;
                         conta_openfiles_;
			 chama_url_;
                         ;;
              qa|QA)
                         IP=10.129.44.196;
			 echo "Server Server: AZR-TOS-QA"
			 conta_memoria_;
			 valida_jboss_;
    			 conta_pool_;
                         conta_openfiles_;
			 chama_url_;
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
