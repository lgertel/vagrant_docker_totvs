FROM hnakamur/rails
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

ADD unicorn /etc/monit.d/unicorn
ADD up.sh /opt/monit/unicorn/up.sh
ADD down.sh /opt/monit/unicorn/down.sh

VOLUME ["/data/app2"]
WORKDIR "/data/app2"
