install: /usr/lib64/varnish/vmods/libvmod_example.so

/usr/lib64/varnish/vmods/libvmod_example.so: libvmod_example.so
	sudo install -m 755 libvmod_example.so /usr/lib64/varnish/vmods/libvmod_example.so

libvmod_example.so: libvmod_example.go
	go build -v -x -buildmode=c-shared libvmod_example.go vcc_if.go
	chmod 755 libvmod_example.so

clean:
	-rm libvmod_example.so
