#ifndef IDENTITY_H
#define IDENTITY_H

// Identity interface client reference
typedef const char *(*username_t)(const int64_t);
typedef struct {
	int64_t context;
  username_t username;
} identity_t;

#endif
