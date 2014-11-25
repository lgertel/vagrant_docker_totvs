#!/bin/sh
docker run -d --name mysql -p 3306:3306 -v /var/host_lib/mysql:/var/lib/mysql -t hnakamur/mysql
