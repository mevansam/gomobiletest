package main

import "C"

import (
	"unsafe"

	"appbricks.io/gomobiletest/greeter"
	"appbricks.io/gomobiletest/person"
)

// pool of allocated greeter instances passed
// to the caller. this prevents the instances
// from being garbage collected by the go runtime
var greeterPool = make(map[uintptr]*greeter.Greeter)

//export GreeterNewGreeter
func GreeterNewGreeter(hPrinter uintptr) uintptr {
	greeter := greeter.NewGreeter(&printerStub{hPrinter: hPrinter})
	greeterPtr := uintptr(unsafe.Pointer(greeter))
	greeterPool[greeterPtr] = greeter
	return greeterPtr
}

//export GreeterFreeGreeter
func GreeterFreeGreeter(goGreeter uintptr) {
	delete(greeterPool, goGreeter)
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
