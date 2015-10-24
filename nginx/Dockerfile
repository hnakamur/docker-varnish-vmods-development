FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

ADD nginx.repo /etc/yum.repos.d/

RUN yum install -y nginx\
 && yum clean all

EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
