#ifndef PRINTER_H
#define PRINTER_H

// Printer interface client reference
typedef void (*print_t)(const int64_t, const char *s);

typedef struct {
  int64_t context;
  print_t print;
} printer_t;

#endif
