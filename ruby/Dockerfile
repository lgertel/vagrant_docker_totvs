FROM centos:centos7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

ENV RUBY_VERSION 2.1.4

ADD gemrc /root/.gemrc

RUN yum install -y git tar gcc make openssl-devel gdbm-devel compat-db47 \
        readline-devel ncurses-devel tcl-devel byacc libyaml-devel libffi-devel && \
    cd /usr/local/src && \
    git clone https://github.com/sstephenson/ruby-build.git && \
    cd ruby-build && \
    ./install.sh && \
    MAKE_OPTS='-j 4' ruby-build $RUBY_VERSION /usr/local && \
    yum clean all && \
    /usr/local/bin/gem install bundler

CMD ["/bin/bash"]
