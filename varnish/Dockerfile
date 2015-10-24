FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum install -y epel-release https://repo.varnish-cache.org/redhat/varnish-4.1.el7.rpm \
 && yum install -y varnish \
 && yum clean all

ADD default.vcl.template /etc/varnish/
ADD startup.sh /usr/local/sbin/

RUN chmod +x /usr/local/sbin/startup.sh

CMD ["/usr/local/sbin/startup.sh"]
