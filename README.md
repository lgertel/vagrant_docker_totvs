vagrant-docker-rails-development-example
========================================

An example for developping rails applications using multiple rails containers and single mysql container on Vagrant and docker.

- Set up docker in the Vagrant machine with IP address 192.168.33.2
- Docker containers uses bridge network (default)
- Run one mysql container and two rails containers
- Run nginx on the Vagrant machine and proxies to rails app containers
- Run systemd on rails containers to reap zombie processes. This is important!
- Run unicorn via monit on rails containers.
- You can access two rails app with the following url. For the first time boot, you must wait a couple of minutes for bundle install, bundle exec rake db:create, bundle exec rake db:migrate
http://app1.192.168.33.2.xip.io
http://app2.192.168.33.2.xip.io
