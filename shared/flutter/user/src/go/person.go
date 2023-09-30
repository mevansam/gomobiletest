package main

// #include <stdlib.h>
// #include <stdio.h>
// #include <sys/types.h>
//
// #include "../identity.h"
//
// static const char *identityUsername(void *ref) {
//	identity_t *identity = (identity_t *)ref;
// 	return identity->username(identity->context);
// }
import "C"

import (
	"unsafe"

	"appbricks.io/gomobiletest/person"
)

// pool of allocated person instances passed
// to the caller. this prevents the instances
// from being garbage collected by the go runtime
var personPool = make(map[uintptr]*person.Person)

// Stub for calling caller's
// identity interface via cgo
type identityStub struct {
	// Handle (identity_t) to caller's 
	// identity interface reference
	hIdentity uintptr
}

func (i *identityStub) Username() string {
	cusername := C.identityUsername(unsafe.Pointer(i.hIdentity))
	username := C.GoString(cusername)
	C.free(unsafe.Pointer(cusername))
	return username
}

//export PersonNewPerson
func PersonNewPerson(hIdentity uintptr) uintptr {
	person := person.NewPerson(&identityStub{hIdentity: hIdentity})
	personPtr := uintptr(unsafe.Pointer(person))
	personPool[personPtr] = person
	return personPtr
}

//export PersonFreePerson
func PersonFreePerson(goPerson uintptr) {
	delete(personPool, goPerson)
}

//export PersonAge
func PersonAge(goPerson uintptr) *C.char {
	if goPerson != 0 {
		person := (*person.Person)(unsafe.Pointer(goPerson))
		return C.CString(person.Age())
	} else {
		panic("PersonAge called with nil pointer")
	}
}
