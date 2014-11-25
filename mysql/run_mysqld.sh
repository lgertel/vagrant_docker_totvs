#!/bin/sh

mysql_root_password=$1

if [ -d /var/lib/mysql/mysql ]; then
  exec mysqld_safe
else
  mysql_install_db --datadir=/var/lib/mysql --user=mysql
  mysqld_safe &
  sleep 10
  echo ${mysql_root_password} | awk 'NR == 1 { \
    escaped_root_password = $0; \
    gsub("\047", "\047\047", escaped_root_password); \
    printf("SET PASSWORD=PASSWORD(\047%s\047);", escaped_root_password); \
    printf("SET @@old_passwords=1; UPDATE mysql.user SET Password=PASSWORD(\047%s\047), password_expired=\047N\047 WHERE User=\047root\047 and plugin = \047mysql_old_password\047;", escaped_root_password); \
    printf("SET @@old_passwords=0; UPDATE mysql.user SET Password=PASSWORD(\047%s\047), password_expired=\047N\047 WHERE User=\047root\047 and plugin in (\047\047, \047mysql_native_password\047);", escaped_root_password); \
    printf("SET @@old_passwords=2; UPDATE mysql.user SET authentication_string=PASSWORD(\047%s\047), password_expired=\047N\047 WHERE User=\047root\047 and plugin = \047sha256_password\047;", escaped_root_password); \
    printf("DELETE FROM mysql.user WHERE User=\047\047;"); \
    printf("DELETE FROM mysql.user WHERE User=\047root\047 AND Host NOT IN (\047localhost\047, \047127.0.0.1\047, \047::1\047);"); \
    printf("DELETE FROM mysql.db WHERE Db=\047test\047 OR Db=\047test\\_%\047;"); \
    printf("FLUSH PRIVILEGES;"); \
    printf("GRANT ALL ON *.* TO \047root\047@\047%%\047 IDENTIFIED BY \047%s\047;", escaped_root_password); \
  }' | mysql -uroot
  wait %1
fi
