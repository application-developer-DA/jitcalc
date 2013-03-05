#pragma once

#include <stddef.h>

struct parser {
    void (*parse)(struct parser *parser, int token, double val);
};

void do_lexer(struct parser *parser, const char *str, size_t len);
