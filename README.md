docker-varnish-vmods-development
================================

Dockerfiles for developing varnish VMODs on docker

## How to run

```
docker-compose up -d
```

## Try to build an example VMOD in go

```
docker exec -it dockervarnishvmodsdevelopment_varnish_1 bash -l -c "cd /root/libvmod_go_example && make"
```

However I got the following errors:

```
...
cd /root/libvmod_go_example
pkg-config --cflags varnishapi
pkg-config --libs varnishapi
CGO_LDFLAGS="-g" "-O2" "-lvarnishapi" /usr/local/go/pkg/tool/linux_amd64/cgo -objdir $WORK/command-line-arguments/_obj/ -importpath command-line-arguments -exportheader=$WORK/command-line-arguments/_obj/_cgo_install.h -- -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ libvmod_example.go vcc_if.go
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/_cgo_main.o -c $WORK/command-line-arguments/_obj/_cgo_main.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/_cgo_export.o -c $WORK/command-line-arguments/_obj/_cgo_export.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/libvmod_example.cgo2.o -c $WORK/command-line-arguments/_obj/libvmod_example.cgo2.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/vcc_if.cgo2.o -c $WORK/command-line-arguments/_obj/vcc_if.cgo2.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -o $WORK/command-line-arguments/_obj/_cgo_.o $WORK/command-line-arguments/_obj/_cgo_main.o $WORK/command-line-arguments/_obj/_cgo_export.o $WORK/command-line-arguments/_obj/libvmod_example.cgo2.o $WORK/command-line-arguments/_obj/vcc_if.cgo2.o -g -O2 -lvarnishapi
# command-line-arguments
/tmp/go-build219936183/command-line-arguments/_obj/libvmod_example.cgo2.o: In function `_cgo_d098f44947dd_Cfunc_WS_Reserve':
./libvmod_example.go:64: undefined reference to `WS_Reserve'
/tmp/go-build219936183/command-line-arguments/_obj/libvmod_example.cgo2.o: In function `_cgo_d098f44947dd_Cfunc_WS_Release':
./libvmod_example.go:50: undefined reference to `WS_Release'
/usr/lib/gcc/x86_64-redhat-linux/4.8.3/../../../../lib64/libvarnishapi.so: undefined reference to `pow'
/usr/lib/gcc/x86_64-redhat-linux/4.8.3/../../../../lib64/libvarnishapi.so: undefined reference to `round'
collect2: error: ld returned 1 exit status
make: *** [libvmod_example.so] Error 2
```

Functions `WS_Reserve` and `WS_Release` are defined in libvarnishapi.so. I confirmed it with the following command which printed nothing (= no match).

```
docker exec -it dockervarnishvmodsdevelopment_varnish_1 bash -l -c "nm /usr/lib/debug/usr/lib64/libvarnishapi.so.debug | grep -E '(WS_Reserve|WS_Release)'"
```
