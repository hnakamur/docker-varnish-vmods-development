FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum install -y epel-release https://repo.varnish-cache.org/redhat/varnish-4.1.el7.rpm\
 && yum update -y\
 && yum install -y varnish varnish-libs-devel varnish-debuginfo python-docutils autoconf automake libtool gcc make yum-utils rpm-build rpmdevtools\
 && yum clean all\
 && rpmdev-setuptree

ADD modify-libvmod-example-spec.sh /usr/local/sbin/

## download, build and install vmod-example for varnish 4.1.x
RUN curl -sL -o /root/rpmbuild/SOURCES/libvmod-example.tar.gz https://github.com/varnish/libvmod-example/archive/4.1.tar.gz\
 && tar xf /root/rpmbuild/SOURCES/libvmod-example.tar.gz --strip-components=1 -C /root/rpmbuild/SPECS/ libvmod-example-4.1/vmod-example.spec\
 && chmod +x /usr/local/sbin/modify-libvmod-example-spec.sh\
 && bash /usr/local/sbin/modify-libvmod-example-spec.sh /root/rpmbuild/SPECS/vmod-example.spec\
 && rpmbuild -bb /root/rpmbuild/SPECS/vmod-example.spec\
 && rpm -i /root/rpmbuild/RPMS/x86_64/vmod-example-*.rpm

ADD default.vcl.template /etc/varnish/
ADD startup.sh /usr/local/sbin/

RUN chmod +x /usr/local/sbin/startup.sh

EXPOSE 6081
CMD ["/usr/local/sbin/startup.sh"]
