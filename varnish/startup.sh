#!/bin/sh
sed 's/{{BACKEND_PORT_80_TCP_ADDR}}/'$BACKEND_PORT_80_TCP_ADDR'/
s/{{BACKEND_PORT_80_TCP_PORT}}/'$BACKEND_PORT_80_TCP_PORT'/' \
  /etc/varnish/default.vcl.template > /etc/varnish/default.vcl

exec /usr/sbin/varnishd -f /etc/varnish/default.vcl -a 0.0.0.0:80 -s malloc,1G -F
