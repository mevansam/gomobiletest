package main

// #include <stdlib.h>
// #include <stdio.h>
// #include <sys/types.h>
//
// #include "../identity.h"
//
// static const char *identityUserid(void *ref) {
//	identity_t *identity = (identity_t *)ref;
// 	return identity->userid(identity->context);
// }
//
// static const char *identityUsername(void *ref) {
//	identity_t *identity = (identity_t *)ref;
// 	return identity->username(identity->context);
// }
//
// static const char *identityAvatar(void *ref) {
//	identity_t *identity = (identity_t *)ref;
// 	return identity->avatar(identity->context);
// }
//
import "C"

import (
	"unsafe"
)

// Stub for calling caller's
// identity interface via cgo
type identityStub struct {
	// Handle (identity_t) to caller's 
	// identity interface reference
	hIdentity uintptr
}

func (i *identityStub) UserID() string {
	cuserid := C.identityUserid(unsafe.Pointer(i.hIdentity))
	userid := C.GoString(cuserid)
	C.free(unsafe.Pointer(cuserid))
	return userid
}

func (i *identityStub) Username() string {
	cusername := C.identityUsername(unsafe.Pointer(i.hIdentity))
	username := C.GoString(cusername)
	C.free(unsafe.Pointer(cusername))
	return username
}

func (i *identityStub) Avatar() string {
	cavatar := C.identityAvatar(unsafe.Pointer(i.hIdentity))
	avatar := C.GoString(cavatar)
	C.free(unsafe.Pointer(cavatar))
	return avatar
}
