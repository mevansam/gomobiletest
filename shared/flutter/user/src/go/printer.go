package main

// #include <stdlib.h>
// #include <stdio.h>
// #include <sys/types.h>
//
// #include "../printer.h"
//
// static void print(void *ref, const char *s) {
// 	printer_t *printer = (printer_t *)ref;
// 	printer->print(printer->context, s);
// }
import "C"

import (
	"unsafe"
)

// stub for calling caller's
// printer interface via cgo
type printerStub struct {
	// handle (printer_t) to caller's 
	// printer interface reference
	hPrinter uintptr
}

func (p *printerStub) Print(s string) {
	cs := C.CString(s)
	C.print(unsafe.Pointer(p.hPrinter), cs)
	C.free(unsafe.Pointer(cs))
}
