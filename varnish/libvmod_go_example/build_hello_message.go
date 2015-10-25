package main

/*
#include <stdio.h>
#include <stdlib.h>

unsigned build_hello_message(char *p, unsigned u, char *name) {
        return snprintf(p, u, "Hello, %s", name);
}
*/
import "C"
