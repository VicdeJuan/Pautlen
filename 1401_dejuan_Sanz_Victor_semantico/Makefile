CC = gcc
CFLAGS = -ggdb -D_GNU_SOURCE
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
TOZIP = Makefile alfa.* pruebaSintactico.c

.PHONY: clean pack final

all: mkdirs $(EXECUTABLE)

mkdirs:
	@mkdir -p includes
	@mkdir -p src

src/y.tab.c: alfa.y
	@bison -yv --defines=includes/y.tab.h -o src/y.tab.c alfa.y

src/lex.yy.c: alfa.l
	@flex --header-file=includes/lex.yy.h -o src/lex.yy.c alfa.l 

$(EXECUTABLE): src/y.tab.c src/lex.yy.c
	$(CC) $(CFLAGS) $(INCFLAG) -o $(EXECUTABLE) $^ pruebaSintactico.c

BISON: 
	@bison -yv  --report=state --defines=includes/y.tab.h -o src/y.tab.c alfa.y

FLEX:
	@flex --header-file=includes/lex.yy.h -o src/lex.yy.c alfa.l 


final: all clean pack

clean:
	$(RM) *~ $(EXECUTABLE)
	$(RM) -r $(INCDIR)/* $(SRCDIR)/*

pack:
	zip -r $(DELIVER)_tabla.zip . -i $(TOZIP)