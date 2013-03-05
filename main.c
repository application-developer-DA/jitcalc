#include "compile.h"

#include <stdio.h>
#include <string.h>

#include <jit/jit.h>

int main()
{
    jit_context_t ctx = jit_context_create();

    while (1)
    {
	func_t func;
	double x;
        int a;
        char buf[1024];
	printf("jitcalc> ");
        if (!fgets(buf, sizeof(buf), stdin))
            break;
	if (strchr("\r\n", buf[0]))
            continue;
	func = compile(ctx, buf, strlen(buf));

	for (a = 0; a < 3; ++a)
	{
	    x = func((double)a, (double)2, (double)7);
	    printf("func(%lf, 2, 7) = %lf\n", (double)a, x);
        }
    }

    jit_context_destroy(ctx);

    return 0;
}
