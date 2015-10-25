install: /usr/lib64/varnish/vmods/libvmod_example.so

/usr/lib64/varnish/vmods/libvmod_example.so: .libs/libvmod_example.so
	install -m 755 .libs/libvmod_example.so /usr/lib64/varnish/vmods/libvmod_example.so

.libs/libvmod_example.so: libvmod_example.go
	#go build -v -x -work -buildmode=c-shared libvmod_example.go vcc_if.go
	go tool cgo -- -I/usr/include/varnish -fPIC -shared -Wl,-soname -Wl,libvmod_example.so libvmod_example.go vcc_if.go build_hello_message.go
	mkdir -p .deps
	/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT vmod_example.lo -MD -MP -MF .deps/vmod_example.Tpo -c -o vmod_example.lo _obj/libvmod_example.cgo2.c
	/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT vcc_if.lo -MD -MP -MF .deps/vcc_if.Tpo -c -o vcc_if.lo _obj/vcc_if.cgo2.c
	/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT build_hello_message.lo -MD -MP -MF .deps/build_hello_message.Tpo -c -o build_hello_message.lo _obj/build_hello_message.cgo2.c
	/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT _cgo_export.lo -MD -MP -MF .deps/_cgo_export.Tpo -c -o _cgo_export.lo _obj/_cgo_export.c
	/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT _cgo_main.lo -MD -MP -MF .deps/_cgo_main.Tpo -c -o _cgo_main.lo _obj/_cgo_main.c
	/bin/sh ../libtool  --tag=CC   --mode=link gcc -std=gnu99  -g -O2 -module -export-dynamic -avoid-version -shared  -o libvmod_example.la -rpath /usr/lib64/varnish/vmods vmod_example.lo vcc_if.lo build_hello_message.lo _cgo_export.lo _cgo_main.lo
#_obj/_cgo_export.c  _obj/_cgo_main.c  _obj/libvmod_example.cgo2.c  _obj/vcc_if.cgo2.c
	chmod 755 .libs/libvmod_example.so

clean:
	-rm libvmod_example.so
