package main

import "C"

import (
	"unsafe"

	"appbricks.io/gomobiletest/person"
)

// pool of allocated person instances passed
// to the caller. this prevents the instances
// from being garbage collected by the go runtime
var personPool = make(map[uintptr]*person.Person)

//export PersonNewPerson
func PersonNewPerson(hIdentity, hErrorHandler uintptr) uintptr {
	if person := person.NewPerson(
		&identityStub{hIdentity: hIdentity},
		&errorHandlerStub{hErrorHandler: hErrorHandler},
	); person != nil {
		personPtr := uintptr(unsafe.Pointer(person))
		personPool[personPtr] = person
		return personPtr
	}
	return 0
}

//export PersonFreePerson
func PersonFreePerson(goPerson uintptr) {
	delete(personPool, goPerson)
}

//export PersonFullName
func PersonFullName(goPerson uintptr) *C.char {
	if goPerson != 0 {
		person := (*person.Person)(unsafe.Pointer(goPerson))
		return C.CString(person.FullName)
	} else {
		panic("PersonFullName called with nil pointer")
	}
}

//export PersonAddress
func PersonAddress(goPerson uintptr) *C.char {
	if goPerson != 0 {
		person := (*person.Person)(unsafe.Pointer(goPerson))
		return C.CString(person.Address)
	} else {
		panic("PersonAddress called with nil pointer")
	}
}

//export PersonDOB
func PersonDOB(goPerson uintptr) *C.char {
	if goPerson != 0 {
		person := (*person.Person)(unsafe.Pointer(goPerson))
		return C.CString(person.DOB)
	} else {
		panic("PersonDOB called with nil pointer")
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
