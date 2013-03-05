#include "calclex.h"

#include "calclalr.h"
#include <stddef.h>
#include <math.h>

%%{
    machine calc;
    alphtype char;

    number = ( [0-9]+  >{ num = 0; }  ${ num = 10 * num + (*p - '0'); } )
             ( '.' [0-9]+
                 >{ fac = 10; }
                 ${ num = num + (double)(*p - '0')/fac; fac *= 10; }
             )? ;

    main := |*

        space;

        number => { emit2(NUMBER, num); };
 
        '+'   => { emit(PLUS); };
        '-'   => { emit(MINUS); };
        '*'   => { emit(MUL); };
        '/'   => { emit(DIV); };
        '^'  => { emit(POW); };

        '('   => { emit(LPAREN); };
        ')'   => { emit(RPAREN); };

	'X'i  => { emit2(VARIABLE, 0); };
	'Y'i  => { emit2(VARIABLE, 1); };
	'Z'i  => { emit2(VARIABLE, 2); };

	'PI'i => { emit2(NUMBER, M_PI); };
	'E'i  => { emit2(NUMBER, M_E); };

	'sqrt'i => { emit(SQRT); };
	'sin'i  => { emit(SIN); };
	'cos'i  => { emit(COS); };
	'tan'i  => { emit(TAN); };

    *|;

}%%

%%write data;

#define emit2(T, V) parser->parse(parser, T, V)
#define emit(T) emit2(T, 0) 

void do_lexer(struct parser *parser, const char* str, size_t len)
{
    int cs;
    const char *p = str;
    const char *pe = p + len;
    const char *eof = pe;
    const char *ts, *te;
    int act;

    double num;
    unsigned fac;

    %%write init;
    %%write exec;

    emit(0); /* EOF */ 
}
