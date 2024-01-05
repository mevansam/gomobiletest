#ifndef IDENTITY_H
#define IDENTITY_H

// Identity interface client reference
typedef const char *(*userid_t)(const int64_t);
typedef const char *(*username_t)(const int64_t);
typedef const char *(*avatar_t)(const int64_t);

typedef struct {
	int64_t context;
  userid_t userid;
  username_t username;
  avatar_t avatar;
} identity_t;

#endif
