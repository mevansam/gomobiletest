#ifndef PERSON_H
#define PERSON_H

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
#include "identity.h"

FFI_PLUGIN_EXPORT void *PersonNewPerson(identity_t *h_identity);
FFI_PLUGIN_EXPORT void PersonFreePerson(void *go_person);
FFI_PLUGIN_EXPORT const char *PersonFullName(void *go_person);
FFI_PLUGIN_EXPORT const char *PersonAddress(void *go_person);
FFI_PLUGIN_EXPORT const char *PersonDOB(void *go_person);
FFI_PLUGIN_EXPORT const char *PersonAge(void *go_person);

#endif
