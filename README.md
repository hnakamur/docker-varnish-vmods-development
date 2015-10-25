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

I read these and added `-Wl,--dynamic-list=syms.txt` to LDFLAGS.

* http://stackoverflow.com/a/6298434/1391518
* https://sourceware.org/ml/binutils/2010-01/msg00418.html

However I still got the following errors:

```
...
cd /root/libvmod_go_example
pkg-config --cflags varnishapi
pkg-config --libs varnishapi
CGO_LDFLAGS="-g" "-O2" "-Wl,--dynamic-list=syms.txt" "-lvarnishapi" /usr/local/go/pkg/tool/linux_amd64/cgo -objdir $WORK/command-line-arguments/_obj/ -importpath command-line-arguments -exportheader=$WORK/command-line-arguments/_obj/_cgo_install.h -- -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ libvmod_example.go vcc_if.go
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/_cgo_main.o -c $WORK/command-line-arguments/_obj/_cgo_main.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/_cgo_export.o -c $WORK/command-line-arguments/_obj/_cgo_export.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/libvmod_example.cgo2.o -c $WORK/command-line-arguments/_obj/libvmod_example.cgo2.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -I/usr/include/varnish -I $WORK/command-line-arguments/_obj/ -g -O2 -o $WORK/command-line-arguments/_obj/vcc_if.cgo2.o -c $WORK/command-line-arguments/_obj/vcc_if.cgo2.c
gcc -I . -fPIC -m64 -pthread -fmessage-length=0 -o $WORK/command-line-arguments/_obj/_cgo_.o $WORK/command-line-arguments/_obj/_cgo_main.o $WORK/command-line-arguments/_obj/_cgo_export.o $WORK/command-line-arguments/_obj/libvmod_example.cgo2.o $WORK/command-line-arguments/_obj/vcc_if.cgo2.o -g -O2 -Wl,--dynamic-list=syms.txt -lvarnishapi
# command-line-arguments
/tmp/go-build594609400/command-line-arguments/_obj/libvmod_example.cgo2.o: In function `_cgo_eec7db90cb24_Cfunc_WS_Reserve':
./libvmod_example.go:65: undefined reference to `WS_Reserve'
/tmp/go-build594609400/command-line-arguments/_obj/libvmod_example.cgo2.o: In function `_cgo_eec7db90cb24_Cfunc_WS_Release':
./libvmod_example.go:51: undefined reference to `WS_Release'
/usr/lib/gcc/x86_64-redhat-linux/4.8.3/../../../../lib64/libvarnishapi.so: undefined reference to `pow'
/usr/lib/gcc/x86_64-redhat-linux/4.8.3/../../../../lib64/libvarnishapi.so: undefined reference to `round'
collect2: error: ld returned 1 exit status
make: *** [libvmod_example.so] Error 2
```

Functions `WS_Reserve` and `WS_Release` are not linked in libvarnishapi.so. I confirmed it with the following command which printed nothing (= no match).

```
docker exec -it dockervarnishvmodsdevelopment_varnish_1 bash -l -c "nm /usr/lib/debug/usr/lib64/libvarnishapi.so.debug | grep -E '(WS_Reserve|WS_Release)'"
```

Functions `WS_Reserve` and `WS_Release` are defined in [varnish-4.1.0/bin/varnishd/cache/cache_ws.c](https://github.com/varnish/Varnish-Cache/blob/varnish-4.1.0/bin/varnishd/cache/cache_ws.c#L208-L240). They are linked in varnishd (See https://github.com/varnish/Varnish-Cache/blob/varnish-4.1.0/bin/varnishd/Makefile.am#L52).

However these two functions are not linked in any varnish libraries. I confirmed it with the following command which printed one line but `cache_ws.c` is just mentioned in a comment.

```
$ docker exec -it dockervarnishvmodsdevelopment_varnish_1 bash -l -c "cd /root/rpmbuild/SOURCES/Varnish-Cache-varnish-4.1.0/lib && grep -R cache_ws ."
./libvmod_std/vmod_std_querysort.c:     /* We trust cache_ws.c to align sensibly */
```

I got the following outputs when I ran `make` in `/root/rpmbuild/SOURCES/libvmod-example-4.1\` to build the original [libvmod-example](https://github.com/varnish/libvmod-example/tree/4.1) which is written in C.

```
/usr/share/varnish/vmodtool.py ../src/vmod_example.vcc
/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT vmod_example.lo -MD -MP -MF .deps/vmod_example.Tpo -c -o vmod_example.lo vmod_example.c
libtool: compile:  gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I.. -I/usr/include/varnish -Wall -Werror -g -O2 -MT vmod_example.lo -MD -MP -MF .deps/vmod_example.Tpo -c vmod_example.c  -fPIC -DPIC -o .libs/vmod_example.o
libtool: compile:  gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I.. -I/usr/include/varnish -Wall -Werror -g -O2 -MT vmod_example.lo -MD -MP -MF .deps/vmod_example.Tpo -c vmod_example.c -o vmod_example.o >/dev/null 2>&1
mv -f .deps/vmod_example.Tpo .deps/vmod_example.Plo
/bin/sh ../libtool  --tag=CC   --mode=compile gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -I/usr/include/varnish -Wall -Werror   -g -O2 -MT vcc_if.lo -MD -MP -MF .deps/vcc_if.Tpo -c -o vcc_if.lo vcc_if.c
libtool: compile:  gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I.. -I/usr/include/varnish -Wall -Werror -g -O2 -MT vcc_if.lo -MD -MP -MF .deps/vcc_if.Tpo -c vcc_if.c  -fPIC -DPIC -o .libs/vcc_if.o
libtool: compile:  gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I.. -I/usr/include/varnish -Wall -Werror -g -O2 -MT vcc_if.lo -MD -MP -MF .deps/vcc_if.Tpo -c vcc_if.c -o vcc_if.o >/dev/null 2>&1
mv -f .deps/vcc_if.Tpo .deps/vcc_if.Plo
/bin/sh ../libtool  --tag=CC   --mode=link gcc -std=gnu99  -g -O2 -module -export-dynamic -avoid-version -shared  -o libvmod_example.la -rpath /usr/lib64/varnish/vmods vmod_example.lo vcc_if.lo
libtool: link: gcc -std=gnu99 -shared  -fPIC -DPIC  .libs/vmod_example.o .libs/vcc_if.o    -O2   -Wl,-soname -Wl,libvmod_example.so -o .libs/libvmod_example.so
libtool: link: ( cd ".libs" && rm -f "libvmod_example.la" && ln -s "../libvmod_example.la" "libvmod_example.la" )
```

I tried to `go tool cgo` and `libtool` to get the same result.

```
docker exec -it dockervarnishvmodsdevelopment_varnish_1 bash -l
```

Then I ran the following commands in the varnish container.
This successfully build libvmod_example.so and installed it to /usr/lib64/varnish/vmods/libvmod_example.so.

```
cd /root/rpmbuild/SOURCES/libvmod-example-4.1/libvmod_go_example/
make
```

Then I checked if `/etc/varnish/default.vcl` compiles OK and it's OK.

```
varnishd -C -f /etc/varnish/default.vcl
```

However `varnish_reload_vcl` fails.

```
# varnish_reload_vcl
Loading vcl from /etc/varnish/default.vcl
Current running config name is 0
Using new config name reload_2015-10-25T03:00:23
VCL compiled.
VCL "reload_2015-10-25T03:00:23" Failed initialization
Command failed with error code 106
varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082 vcl.load failed
```

On the other hand, I ran `go build` with `-work` option.

```
# go build -v -x -work -buildmode=c-shared libvmod_example.go vcc_if.go
WORK=/tmp/go-build175624500
runtime
mkdir -p $WORK/runtime/_obj/
mkdir -p $WORK/
...
```

And I saw the generated file list in the work directory.

```
# (cd /tmp/go-build175624500; find . -type f)
./sync/atomic.a
./sync/atomic/_obj/go_asm.h
./sync/atomic/_obj/asm_amd64.o
./command-line-arguments/_obj/libvmod_example.cgo1.go
./command-line-arguments/_obj/_cgo_export.o
./command-line-arguments/_obj/libvmod_example.cgo2.o
./command-line-arguments/_obj/vcc_if.cgo2.o
./command-line-arguments/_obj/vcc_if.cgo1.go
./command-line-arguments/_obj/_cgo_install.h
./command-line-arguments/_obj/_cgo_flags
./command-line-arguments/_obj/_cgo_gotypes.go
./command-line-arguments/_obj/vcc_if.cgo2.c
./command-line-arguments/_obj/_cgo_main.o
./command-line-arguments/_obj/_cgo_export.h
./command-line-arguments/_obj/_cgo_export.c
./command-line-arguments/_obj/libvmod_example.cgo2.c
./command-line-arguments/_obj/_cgo_main.c
./syscall/_obj/go_asm.h
./syscall/_obj/asm.o
./syscall/_obj/asm_linux_amd64.o
./runtime/cgo/_obj/_all.o
./runtime/cgo/_obj/_cgo_import.go
./runtime/cgo/_obj/gcc_util.o
./runtime/cgo/_obj/gcc_amd64.o
./runtime/cgo/_obj/go_asm.h
./runtime/cgo/_obj/gcc_libinit.o
./runtime/cgo/_obj/cgo.cgo1.go
./runtime/cgo/_obj/_cgo_export.o
./runtime/cgo/_obj/gcc_setenv.o
./runtime/cgo/_obj/cgo.cgo2.c
./runtime/cgo/_obj/asm_amd64.o
./runtime/cgo/_obj/_cgo_flags
./runtime/cgo/_obj/_cgo_.o
./runtime/cgo/_obj/_cgo_gotypes.go
./runtime/cgo/_obj/cgo.cgo2.o
./runtime/cgo/_obj/gcc_fatalf.o
./runtime/cgo/_obj/_cgo_main.o
./runtime/cgo/_obj/_cgo_export.h
./runtime/cgo/_obj/_cgo_export.c
./runtime/cgo/_obj/_cgo_main.c
./runtime/cgo/_obj/gcc_linux_amd64.o
./runtime/_obj/go_asm.h
./runtime/_obj/rt0_linux_amd64.o
./runtime/_obj/memclr_amd64.o
./runtime/_obj/asm.o
./runtime/_obj/memmove_amd64.o
./runtime/_obj/asm_amd64.o
./runtime/_obj/duff_amd64.o
./runtime/_obj/sys_linux_amd64.o
./runtime/cgo.a
./sync.a
./runtime.a
./syscall.a
```

When I ran the command below in my Makefile,

```
go tool cgo -- -I/usr/include/varnish -fPIC -shared -Wl,-soname -Wl,libvmod_example.so libvmod_example.go vcc_if.go build_hello_message.go
```

I got the following generated files.

```
# (cd /root/rpmbuild/SOURCES/libvmod-example-4.1/libvmod_go_example && find ./_obj -type f)
./_obj/libvmod_example.cgo1.go
./_obj/vcc_if.cgo1.go
./_obj/_cgo_flags
./_obj/_cgo_.o
./_obj/_cgo_gotypes.go
./_obj/vcc_if.cgo2.c
./_obj/_cgo_export.h
./_obj/_cgo_export.c
./_obj/libvmod_example.cgo2.c
./_obj/build_hello_message.cgo1.go
./_obj/_cgo_main.c
./_obj/build_hello_message.cgo2.c
```

Compare the two file lists, `runtime/cgo/*` and `runtime/_obj/*` files are missing in the case of `go tool cgo`.
Maybe this is the reason why `varnish_reload_vcl` fails.
