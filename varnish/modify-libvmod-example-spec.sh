#!/bin/bash
sed -i.orig '/^%setup -n libvmod-example-trunk/s/trunk/4.1/
/^%build/a\
./autogen.sh
/^%{__make} %{?_smp_mflags} check/s/^/#/
/^mv %{buildroot}\/usr\/share\/doc\/lib%{name} %{buildroot}\/usr\/share\/doc\/%{name}/a\
rm %{buildroot}/usr/lib64/varnish/vmods/libvmod_example.la
' "$@"
