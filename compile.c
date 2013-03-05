#include "compile.h"
#include "calclex.h"

#include <stdlib.h>

// #include <stdio.h>

#include <jit/jit.h>

/* Functions generated by Lemon */
void *calcparsAlloc(void *(*mallocProc)(size_t));
void calcpars(void *parser, int token, double val, jit_function_t func);
void calcparsFree(void *parser, void (*freeProc)(void *));

struct calcparser {
    struct parser p;
    void *parser;
    jit_function_t func;
};

static void do_parser(struct parser *parser, int token, double val)
{
    struct calcparser *pars = (struct calcparser *)parser;
    calcpars(pars->parser, token, val, pars->func);
}

func_t compile(jit_context_t ctx, const char *str, size_t len)
{
    struct calcparser pars;
    pars.p.parse = do_parser;

    pars.parser = calcparsAlloc(malloc);

    jit_context_build_start(ctx);

    {
        jit_type_t param[3] = { jit_type_sys_double, jit_type_sys_double, jit_type_sys_double };
        jit_type_t sig = jit_type_create_signature(jit_abi_cdecl, jit_type_sys_double,
            param, (sizeof(param)/sizeof(*param)), 1);
        pars.func = jit_function_create(ctx, sig);
        jit_type_free(sig);
    }

    do_lexer((struct parser *)&pars, str, len);

    jit_function_compile(pars.func);
    jit_context_build_end(ctx);

    calcparsFree(pars.parser, free);

//     jit_dump_function(stdout, pars.func, "func");

    return (func_t)jit_function_to_closure(pars.func);
}
