package main

import "C"

import (
	"fmt"
	"unsafe"

	"appbricks.io/gomobiletest/greeter"
	"appbricks.io/gomobiletest/person"
)

// Stub for calling caller's
// printer interface via cgo
type printerStub struct {
	hPrinter uintptr
}

func (p *printerStub) PrintSomething(s string) {
	fmt.Println("printerStub.PrintSomething called with", s)
}

//export GreeterNewGreeter
func GreeterNewGreeter(hPrinter uintptr) uintptr {
	return uintptr(unsafe.Pointer(greeter.NewGreeter(&printerStub{hPrinter: hPrinter})))
}

//export GreeterFreeGreeter
func GreeterFreeGreeter(hGreeter uintptr) {
	greeter := (*greeter.Greeter)(unsafe.Pointer(hGreeter))
	if greeter != nil {
		greeter = nil
	}
}

//export GreeterGreet
func GreeterGreet(hGreeter uintptr, hPerson uintptr) {

	if hGreeter != 0 && hPerson != 0 {
		greeter := (*greeter.Greeter)(unsafe.Pointer(hGreeter))
		person := (*person.Person)(unsafe.Pointer(hPerson))
		greeter.Greet(person)

	} else {
		panic("GreeterGreet called with nil pointers")
	}
}
