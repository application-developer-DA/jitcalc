#pragma once

#include <stddef.h>
#include <jit/jit.h>

typedef double (*func_t)(double x, double y, double z);

func_t compile(jit_context_t ctx, const char *s, size_t len);
