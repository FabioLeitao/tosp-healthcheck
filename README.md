# tosp_health_check
Tenta validar diversos comportamentos e status das JVM do TOSP e se necessário ou possível, autocorrigir

Deve ser utilizado sempre com o mesmo suário local que estiver executando o JVM da aplicação, e pode depender de chaves públicas para acesso SSH de usuário com permissão de execução sudoer sem senha para alguns comandos com permissão no systemd (como status e reload de alguns serviços)

Recomendado execução em crontab, passando como parametro a VM:

*/10    *       *       *       *       nice -n 13 ionice -c2 -n7 /home/sc-tos-app/appServer_TOSP/tosp_health_check.sh 002

Alternativamente, é possível rodar apenas o reload_scheduler.sh, sem senha, se configurado corretamente chave publica e sudoer
