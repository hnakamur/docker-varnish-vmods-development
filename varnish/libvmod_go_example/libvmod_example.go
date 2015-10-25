package main

/*
#cgo pkg-config: varnishapi
#cgo LDFLAGS: -Wl,--dynamic-list=syms.txt

#include <stdio.h>
#include <stdlib.h>

#include "vcl.h"
#include "vrt.h"
#include "cache/cache.h"

// #include "vcc_if.h"

extern unsigned build_hello_message(char *p, unsigned u, char *name);
*/
import (
	"C"
)

//export init_function
func init_function(ctx *C.struct_vrt_ctx, priv *C.struct_vmod_priv,
	e C.enum_vcl_event_e) C.int {
	if e != C.VCL_EVENT_LOAD {
		return 0
	}

	/* init what you need */
	return 0
}

//export vmod_hello
func vmod_hello(ctx *C.struct_vrt_ctx, name *C.char) *C.char {
	var p *C.char
	var u, v C.unsigned
	var ws *C.struct_ws = ctx.ws

	u = C.WS_Reserve(ws, C.unsigned(0)) /* Reserve some work space */
	p = ctx.ws.f                        /* Front of workspace area */
	v = C.build_hello_message(p, u, name)
	v++
	if v > u {
		/* No space, reset and leave */
		C.WS_Release(ws, C.unsigned(0))
		return nil
	}
	/* Update work space with what we've used */
	C.WS_Release(ws, C.unsigned(v))
	return p
}

func main() {
}
