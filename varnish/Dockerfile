FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum install -y epel-release https://repo.varnish-cache.org/redhat/varnish-4.1.el7.rpm\
 && yum update -y\
 && yum install -y varnish varnish-libs-devel varnish-debuginfo python-docutils autoconf automake libtool gcc make yum-utils rpm-build rpmdevtools\
 && yum clean all\
 && rpmdev-setuptree

ADD modify-libvmod-example-spec.sh /usr/local/sbin/

## download, build vmod-example for varnish 4.1.x
RUN curl -sL -o /root/rpmbuild/SOURCES/libvmod-example.tar.gz https://github.com/varnish/libvmod-example/archive/4.1.tar.gz\
 && tar xf /root/rpmbuild/SOURCES/libvmod-example.tar.gz -C /root/rpmbuild/SOURCES/\
 && (cd /root/rpmbuild/SOURCES/libvmod-example-4.1\
    && ./autogen.sh\
    && ./configure --prefix=/usr\
    && make)

RUN curl -sL https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz | tar zxf - -C /usr/local\
 && mkdir /root/gocode\
 && echo 'export GOPATH=/root/gocode' >> /root/.bash_profile\
 && echo 'export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"' >> /root/.bash_profile

ADD libvmod_go_example/ /root/libvmod_go_example/
RUN cp /root/rpmbuild/SOURCES/libvmod-example-4.1/{config.h,src/vcc_if.[ch]} /root/libvmod_go_example/

RUN curl -sL https://github.com/varnish/Varnish-Cache/archive/varnish-4.1.0.tar.gz | tar zxf - -C /root/rpmbuild/SOURCES/

ADD default.vcl.template /etc/varnish/
ADD startup.sh /usr/local/sbin/
RUN chmod +x /usr/local/sbin/startup.sh

EXPOSE 6081
CMD ["/usr/local/sbin/startup.sh"]
