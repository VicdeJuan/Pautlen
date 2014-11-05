CC = gcc
CFLAGS = -ggdb
INCFLAG = -I./includes

OBJDIR = obj
SRCDIR = src
INCDIR = includes

INCS := $(wildcard $(INCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%,$(OBJDIR)/% , $(patsubst %.c,%.o, $(SRCS)))
FLEX_GEN := includes/lex.yy.h src/lex.yy.c
BISON_GEN := includes/y.tab.h src/y.tab.c src/y.output


EXECUTABLE = pruebaSintactico

GROUP = 1401
LAST = dejuan_Sanz
NAME = Victor
DELIVER = $(GROUP)_$(LAST)_$(NAME)
TOZIP = $(DELIVER)/src $(DELIVER)/includes $(DELIVER)/Makefile

.PHONY: depend clean pack final

all: BISON FLEX	$(EXECUTABLE)

BISON: alfa.y
	@bison -yv --defines=includes/y.tab.h -o src/y.tab.c alfa.y

FLEX: alfa.l
	@flex --header-file=includes/lex.yy.h -o src/lex.yy.c alfa.l 

$(OBJDIR):
	@echo Creating obj directory
	@mkdir -p $(OBJDIR)

$(EXECUTABLE): $(OBJS) alfa.l alfa.y
	@$(CC) $(CFLAGS) $(INCFLAG) -o $(EXECUTABLE) $(OBJS) $(LFLAGS) $(LIBS) 


$(OBJDIR)/%.o: $(SRCDIR)/%.c  $(INCS) | $(OBJDIR) 
	@echo "$< -> $@"
	$(CC) $(CFLAGS) $(INCFLAG) -c $< -o $@

final: all clean pack

clean:
	$(RM) *~ $(EXECUTABLE)
	$(RM) -r $(OBJDIR) $(FLEX_GEN) $(BISON_GEN)

pack:
	zip -r $(DELIVER)_tabla.zip . -i $(TOZIP)