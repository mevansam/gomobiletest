package main

// #include <stdlib.h>
// #include <stdio.h>
// #include <sys/types.h>
//
// #include "../printer.h"
//
// static void printerPrintSomething(void *ref, const char *s) {
// 	printer_t *printer = (printer_t *)ref;
// 	printer->printSomething(printer->context, s);
// }
import "C"

import (
	"unsafe"

	"appbricks.io/gomobiletest/greeter"
	"appbricks.io/gomobiletest/person"
)

// Stub for calling caller's
// printer interface via cgo
type printerStub struct {
	// Handle (printer_t) to caller's 
	// printer interface reference
	hPrinter uintptr
}

func (p *printerStub) PrintSomething(s string) {
	cs := C.CString(s)
	C.printerPrintSomething(unsafe.Pointer(p.hPrinter), cs)
	C.free(unsafe.Pointer(cs))
}

//export GreeterNewGreeter
func GreeterNewGreeter(hPrinter uintptr) uintptr {
	return uintptr(unsafe.Pointer(greeter.NewGreeter(&printerStub{hPrinter: hPrinter})))
}

//export GreeterFreeGreeter
func GreeterFreeGreeter(goGreeter uintptr) {
	greeter := (*greeter.Greeter)(unsafe.Pointer(goGreeter))
	if greeter != nil {
		greeter = nil
	}
}

//export GreeterGreet
func GreeterGreet(goGreeter uintptr, goPerson uintptr) {
	if goGreeter != 0 && goPerson != 0 {
		greeter := (*greeter.Greeter)(unsafe.Pointer(goGreeter))
		person := (*person.Person)(unsafe.Pointer(goPerson))
		greeter.Greet(person)

	} else {
		panic("GreeterGreet called with nil pointers")
	}
}
