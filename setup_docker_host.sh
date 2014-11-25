#!/bin/sh

# set lang to english to avoid system messages to be printed in Japanese
echo 'export LANG=en_US.utf8' >> /root/.bash_profile

# install dig
yum install -y bind-utils

# configure firewall
if ! (iptables-save | grep '^-A IN_public_allow -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT$'); then
  firewall-cmd --permanent --add-service=http --zone=public
  systemctl restart firewalld.service

  # NOTE: Without restarting docker service, I could not resolve hostnames on the Internet
  # within a container.
  systemctl restart docker.service
fi

if ! rpm -q nginx; then
  cat <<'EOF' > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF

  rpm --import http://nginx.org/keys/nginx_signing.key
  yum install -y nginx

  mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
  cat <<'EOF' > /etc/nginx/nginx.conf

user  nginx;
worker_processes  4;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  120;
    keepalive_requests 100;

    server_tokens off;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
EOF

  cat <<'EOF' > /etc/nginx/conf.d/app1.conf
upstream app1_backend {
  server localhost:3001 max_fails=3 fail_timeout=10s;
}

server {
  listen       80;
  server_name  app1.192.168.33.2.xip.io;

  access_log  /var/log/nginx/app1.192.168.33.2_access.log main;
  error_log   /var/log/nginx/app1.192.168.33.2_error.log  notice;

  client_max_body_size  100M;
  proxy_connect_timeout 60;
  proxy_read_timeout    600;
  proxy_send_timeout    600;

  location / {
    limit_except GET POST PATCH DELETE {}    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    if (!-f $request_filename) { proxy_pass http://app1_backend; }
  }
}
EOF

  cat <<'EOF' > /etc/nginx/conf.d/app2.conf
upstream app2_backend {
  server localhost:3002 max_fails=3 fail_timeout=10s;
}

server {
  listen       80;
  server_name  app2.192.168.33.2.xip.io;

  access_log  /var/log/nginx/app2.192.168.33.2_access.log main;
  error_log   /var/log/nginx/app2.192.168.33.2_error.log  notice;

  client_max_body_size  100M;
  proxy_connect_timeout 60;
  proxy_read_timeout    600;
  proxy_send_timeout    600;

  location / {
    limit_except GET POST PATCH DELETE {}    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    if (!-f $request_filename) { proxy_pass http://app2_backend; }
  }
}
EOF
  systemctl daemon-reload
  systemctl enable nginx
  systemctl start nginx
fi
