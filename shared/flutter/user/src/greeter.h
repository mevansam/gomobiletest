#ifndef GREETER_H
#define GREETER_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

#include "common.h"
#include "printer.h"

FFI_PLUGIN_EXPORT void *GreeterNewGreeter(printer_t *h_printer);
FFI_PLUGIN_EXPORT void GreeterFreeGreeter(void *go_greeter);
FFI_PLUGIN_EXPORT void GreeterGreet(void *go_greeter, void *go_person);

#endif
