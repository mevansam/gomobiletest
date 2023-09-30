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
	"fmt"
	"unsafe"

	"appbricks.io/gomobiletest/person"
)

// Stub for calling caller's
// identity interface via cgo
type identityStub struct {
	// Handle (identity_t) to caller's 
	// identity interface reference
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
func PersonFreePerson(goPerson uintptr) {
	person := (*person.Person)(unsafe.Pointer(goPerson))
	if person != nil {
		person = nil
	}
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
