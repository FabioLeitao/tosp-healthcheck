# tosp_health_check
Tenta validar diversos comportamentos e status das JVM do TOSP e se necessário ou possível, autocorrigir

Deve ser utilizado sempre com o mesmo suário local que estiver executando o JVM da aplicação, e pode depender de chaves públicas para acesso SSH de usuário com permissão de execução sudoer sem senha para alguns comandos com permissão no systemd (como status e reload de alguns serviços)
