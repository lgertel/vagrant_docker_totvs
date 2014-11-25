#!/bin/sh
docker run -i --cap-add=SYS_ADMIN --name app1 --link mysql:mysql -p 3001:3000 -p 2813:2812 -v /vagrant/app1/src:/data/app1 -w /data/app1 -t hnakamur/app1 /bin/bash
