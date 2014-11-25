FROM centos:centos7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum install -y http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm && \
    yum install -y mysql-community-server && \
    yum clean all
RUN mkdir -p /var/run/mysql && \
    chown mysql:mysql /var/run/mysql

VOLUME ["/var/lib/mysql"]
ADD my.cnf /etc/my.cnf
ADD run_mysqld.sh /root/run_mysqld.sh

EXPOSE 3306
CMD ["/root/run_mysqld.sh", "password"]
