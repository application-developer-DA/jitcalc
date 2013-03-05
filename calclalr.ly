%name {calcpars}

%include {
#include <assert.h>
#include <stdlib.h>
#include <jit/jit.h>
#include "calclalr.h"
}

%token_type {double}
%extra_argument {jit_function_t func}
%syntax_error { jit_value_t val = jit_value_create_float64_constant(func, jit_type_sys_double, 1234.5678); jit_insn_return(func, val); }

%left  PLUS MINUS.
%left  MUL DIV.
%right POW.

program ::= expr(A). { jit_insn_return(func, A); }

%type expr {jit_value_t}
%type term {jit_value_t}

expr(X) ::= expr(A) PLUS term(B).  { X = jit_insn_add(func, A, B); }
expr(X) ::= expr(A) MINUS term(B). { X = jit_insn_sub(func, A, B); }
expr(X) ::= PLUS term(A).          { X = A; }
expr(X) ::= MINUS term(A).         { X = jit_insn_neg(func, A); }
expr(X) ::= term(A).               { X = A; }
term(X) ::= term(A) MUL term(B).   { X = jit_insn_mul(func, A, B); }
term(X) ::= term(A) DIV term(B).   { X = jit_insn_div(func, A, B); }
term(X) ::= LPAREN expr(A) RPAREN. { X = A; }
term(X) ::= term(A) POW term(B).   { X = jit_insn_pow(func, A, B); }

term(X) ::= SQRT LPAREN expr(A) RPAREN.   { X = jit_insn_sqrt(func, A); }

term(X) ::= NUMBER(T).
    { X = jit_value_create_float64_constant(func, jit_type_sys_double, T); }

term(X) ::= VARIABLE(T).
    { X = jit_value_get_param(func, (unsigned)T); }

term(X) ::= SIN LPAREN expr(A) RPAREN.    { X = jit_insn_sin(func, A); }
term(X) ::= COS LPAREN expr(A) RPAREN.    { X = jit_insn_cos(func, A); }
term(X) ::= TAN LPAREN expr(A) RPAREN.    { X = jit_insn_tan(func, A); }
