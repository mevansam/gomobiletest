package main

import "C"

import (
	"fmt"
	"unsafe"

	"appbricks.io/gomobiletest/person"
)

// Stub for calling caller's
// identity interface via cgo
type identityStub struct {
	hIdentity uintptr
}

func (i *identityStub) Username() string {
	fmt.Println("identityStub.Username - returning anika")
	return "anika"
}

//export PersonNewPerson
func PersonNewPerson(hIdentity uintptr) uintptr {
	return uintptr(unsafe.Pointer(person.NewPerson(&identityStub{hIdentity: hIdentity})))
}

//export PersonFreePerson
func PersonFreePerson(hPerson uintptr) {
	person := (*person.Person)(unsafe.Pointer(hPerson))
	if person != nil {
		person = nil
	}
}

//export PersonAge
func PersonAge(hPerson uintptr) *C.char {
	person := (*person.Person)(unsafe.Pointer(hPerson))
	if person != nil {
		return C.CString(person.Age())
	}
	return nil
}
