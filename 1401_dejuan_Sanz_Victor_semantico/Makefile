CC = gcc
CFLAGS = -ggdb -D_GNU_SOURCE -g -Wall -pedantic -std=c99 
INCFLAG = -I./includes

SRCDIR = src
INCDIR = includes
OBJDIR = obj
AUXDIR = src/aux

INCS := $(wildcard $(INCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%,$(OBJDIR)/% , $(patsubst %.c,%.o, $(SRCS)))


FLEX_GEN := includes/lex.yy.h $(AUXDIR)/lex.yy.c
BISON_GEN := includes/y.tab.h $(AUXDIR)/y.tab.c $(AUXDIR)/y.output

BISON_FILE := alfa.y
FLEX_FILE := alfa.l


EXECUTABLE = pruebaSeman


GROUP = 1401
LAST = dejuan_Sanz
NAME = Victor
DELIVER = $(GROUP)_$(LAST)_$(NAME)


FMT_BOLD := $(shell tput bold)
FMT_NORM := $(shell tput sgr0)


.PHONY: clean pack final

all: $(EXECUTABLE)

$(OBJDIR):
	@echo Creating obj directory
	@mkdir -p $(OBJDIR)

$(AUXDIR)/y.tab.c: $(BISON_FILE)
	@echo $(FMT_BOLD) "Generating y.yab.c" $(FMT_NORM)
	bison -yv --defines=includes/y.tab.h -o $(AUXDIR)/y.tab.c $^

$(AUXDIR)/lex.yy.c: $(FLEX_FILE)
	@echo $(FMT_BOLD) "Generating lex.yy.c" $(FMT_NORM)
	flex --header-file=includes/lex.yy.h -o $(AUXDIR)/lex.yy.c $^ 


$(EXECUTABLE): $(OBJS) $(AUXDIR)/y.tab.c $(AUXDIR)/lex.yy.c
	@echo $(FMT_BOLD) Generating $(EXECUTABLE)  $(FMT_NORM)	
	$(CC) $(CFLAGS) $(INCFLAG) -o $(EXECUTABLE) $(OBJS)


$(OBJDIR)/%.o: $(SRCDIR)/%.c  $(INCS) | $(OBJDIR) 
	@echo "$< -> $@"
	@$(CC) $(CFLAGS) $(INCFLAG) -c $< -o $@


BISON: 
	@bison -yv  --report=state --defines=$(INCDIR)/y.tab.h -o $(AUXDIR)/y.tab.c $(BISON_FILE)

FLEX:
	@flex --header-file=includes/lex.yy.h -o $(AUXDIR)/lex.yy.c $(FLEX_FILE) 


final: all clean pack

clean:
	$(RM) *~ $(EXECUTABLE)
	$(RM) -r $(FLEX_GEN) $(BISON_GEN)
	$(RM) -r $(OBJDIR)

pack:
	zip -r $(DELIVER)_tabla.zip . -i $(TOZIP)