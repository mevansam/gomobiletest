#ifndef ERROR_H
#define ERROR_H

// ErrorHandler interface client reference
typedef void (*handle_error_t)(const int64_t, const int, const char *);
typedef struct {
	int64_t context;
  handle_error_t handle_error;
} error_handler_t;

#endif
