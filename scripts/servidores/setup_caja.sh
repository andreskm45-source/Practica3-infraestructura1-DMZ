#!/bin/bash
set -e
bash "$(dirname "$0")/00_repositorios_apt.sh"
apt install -y nginx openssh-server mariadb-client
echo "<h1>Sistema de Caja</h1>" > /var/www/html/index.html
systemctl enable --now nginx
systemctl enable --now ssh
id rafael >/dev/null 2>&1 || adduser --gecos "" rafael
curl -s http://localhost
