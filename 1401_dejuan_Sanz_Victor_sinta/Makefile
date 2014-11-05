CC = gcc
CFLAGS = -ggdb
INCFLAG = -I./includes

SRCDIR = src
INCDIR = includes

INCS := $(wildcard $(INCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
FLEX_GEN := includes/lex.yy.h src/lex.yy.c
BISON_GEN := includes/y.tab.h src/y.tab.c src/y.output


EXECUTABLE = pruebaSintactico

GROUP = 1401
LAST = dejuan_Sanz
NAME = Victor
DELIVER = $(GROUP)_$(LAST)_$(NAME)
TOZIP = $(DELIVER)/src $(DELIVER)/includes $(DELIVER)/Makefile

.PHONY: clean pack final

all: $(EXECUTABLE)

src/y.tab.c: alfa.y
	@bison -yv -Wnone --defines=includes/y.tab.h -o src/y.tab.c alfa.y

src/lex.yy.c: alfa.l
	@flex --header-file=includes/lex.yy.h -o src/lex.yy.c alfa.l 

$(EXECUTABLE): src/y.tab.c src/lex.yy.c
	$(CC) $(CFLAGS) $(INCFLAG) -o $(EXECUTABLE) $^ pruebaSintactico.c


final: all clean pack

clean:
	$(RM) *~ $(EXECUTABLE)
	$(RM) -r $(FLEX_GEN) $(BISON_GEN)

pack:
	zip -r $(DELIVER)_tabla.zip . -i $(TOZIP)