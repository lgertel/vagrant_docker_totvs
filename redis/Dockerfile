FROM centos:centos7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

ENV REDIS_VERSION 2.8.17

RUN yum install -y tar gcc make && \
    yum clean all && \
    cd /usr/local/src/ && \
    curl -O http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz && \
    tar xf redis-${REDIS_VERSION}.tar.gz && \
    cd redis-${REDIS_VERSION} && \
    make && \
    make install && \
    cd .. && \
    rm -r redis-${REDIS_VERSION}.tar.gz redis-${REDIS_VERSION}

EXPOSE 6379
CMD ["/usr/local/bin/redis-server"]
