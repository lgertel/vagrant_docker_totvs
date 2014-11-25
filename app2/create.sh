#!/bin/sh
docker create --cap-add=SYS_ADMIN --name app2 --link mysql:mysql -p 3002:3000 -p 2814:2812 -v /vagrant/app2/src:/data/app2 -w /data/app2 -t hnakamur/app2
