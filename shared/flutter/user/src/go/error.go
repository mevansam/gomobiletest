package main

// #include <stdlib.h>
// #include <stdio.h>
// #include <sys/types.h>
//
// #include "../error.h"
//
// static void errorHandlerHandleError(void *ref, int code, const char *message) {
//	error_handler_t *error_handler = (error_handler_t *)ref;
// 	error_handler->handle_error(error_handler->context, code, message);
// }
import "C"

import (
	"unsafe"
)

// Stub for calling caller's error
// handler interface via cgo
type errorHandlerStub struct {
	// Handle (identity_t) to caller's 
	// identity interface reference
	hErrorHandler uintptr
}

func (h *errorHandlerStub) HandleError(code int, message string) {
	cmessage := C.CString(message)
	C.errorHandlerHandleError(
		unsafe.Pointer(h.hErrorHandler), 
		C.int(code), cmessage,
	)
	C.free(unsafe.Pointer(cmessage))
}
