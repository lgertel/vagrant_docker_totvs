FROM hnakamur/ruby
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

# * Uninstall fakesystemd and install systemd
#   See http://qiita.com/yunano/items/9637ee21a71eba197345
# * Install mysql-community-devel, mysql-community-client and ImageMagick-devel for a rails app
# * Install monit
# * Install node.js for asset pipeline

# NOTE: Disable mirrorlist and enable baseurl in epel.repo to avoid the error below.
#
# Loaded plugins: fastestmirror
# http://ftp.kddilabs.jp/Linux/packages/fedora/epel/7/x86_64/repodata/repomd.xml: [Errno -1] repomd.xml does not match metalink for epel
# Trying other mirror.

RUN yum swap -y fakesystemd systemd && \
    yum install -y http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm && \
    yum install -y mysql-community-devel mysql-community-client ImageMagick-devel epel-release && \
    sed -i.bak -e 's/^#baseurl=/baseurl=/;s/^mirrorlist=/#&/' /etc/yum.repos.d/epel.repo && \
    yum install -y monit && \
    yum clean all && \
    sed -i 's/use address localhost  # only accept connection from localhost.*/use address 0.0.0.0    # accept connection from any host/' /etc/monitrc && \
    systemctl enable monit && \
    cd /usr/local/src && \
    curl -O http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x64.tar.gz && \
    tar xf node-v0.10.33-linux-x64.tar.gz --strip-components 1 -C /usr/local

EXPOSE 2812
CMD ["/sbin/init"]
