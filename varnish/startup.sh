#!/bin/sh
sed 's/{{BACKEND_PORT_80_TCP_ADDR}}/'$BACKEND_PORT_80_TCP_ADDR'/
s/{{BACKEND_PORT_80_TCP_PORT}}/'$BACKEND_PORT_80_TCP_PORT'/' \
  /etc/varnish/default.vcl.template > /etc/varnish/default.vcl

source /etc/varnish/varnish.params
exec /usr/sbin/varnishd \
  -f $VARNISH_VCL_CONF \
  -a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \
  -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \
  -S $VARNISH_SECRET_FILE \
  -s $VARNISH_STORAGE \
  -F
