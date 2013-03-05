PHONY: all clean

all: calc.exe
clean:
	-rm *.o calclalr.c calclalr.h calclex.c 

calc.exe : main.o compile.o calclex.o calclalr.o
	gcc -o $@ $^ libjit.a -lm -lpthread

calclex.o : calclex.c calclalr.h

%.o : %.c
	gcc -c -O2 -Werror -I include -o $@ $< 

%.c : %.rl
	ragel -o $@ $<

%.c %.h : %.ly
	lemon -q $<
