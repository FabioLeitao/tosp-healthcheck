# Security Policy

## Supported Versions

Any BASH version after 5

You may need to add an SSH RSA or ED25519 key as authorized key into a SUDOER User .ssh folder to allow "remote access" their credential to rum systemd commands into yout Linux server 

There are several files it assumes you need to change to the correct password

## Sudoers file

Cmnd_Alias SCHEDULERATHENAS = /usr/local/bin/status_scheduler.sh, /usr/local/bin/start_scheduler.sh, /usr/local/bin/stop_scheduler.sh, /usr/sbin/lsof, /usr/bin/journalctl

<usuario> ALL = NOPASSWD: SCHEDULERATHENAS
