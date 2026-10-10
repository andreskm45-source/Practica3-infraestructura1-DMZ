#!/bin/bash
set -e
: "${DB_PASS_CAJA:?Defina DB_PASS_CAJA}"
: "${DB_PASS_INV:?Defina DB_PASS_INV}"
bash "$(dirname "$0")/00_repositorios_apt.sh"
apt install -y mariadb-server openssh-server
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl enable --now mariadb
systemctl restart mariadb
mysql -e "CREATE DATABASE IF NOT EXISTS negocio;"
mysql -e "CREATE USER IF NOT EXISTS 'caja'@'10.7.84.131' IDENTIFIED BY '${DB_PASS_CAJA}';"
mysql -e "CREATE USER IF NOT EXISTS 'inv'@'10.7.84.130' IDENTIFIED BY '${DB_PASS_INV}';"
mysql -e "GRANT ALL ON negocio.* TO 'caja'@'10.7.84.131';"
mysql -e "GRANT ALL ON negocio.* TO 'inv'@'10.7.84.130';"
mysql -e "FLUSH PRIVILEGES;"
systemctl enable --now ssh
id rafael >/dev/null 2>&1 || adduser --gecos "" rafael
mysql -e "SHOW DATABASES;"
