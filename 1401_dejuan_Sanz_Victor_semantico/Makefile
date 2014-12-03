CC = gcc
CFLAGS = -ggdb -D_GNU_SOURCE -g 
#-Wall -pedantic -std=c99 
INCFLAG = -I./includes

SRCDIR = src
INCDIR = includes
OBJDIR = obj
AUXSRCDIR = auxsrc

INCS := $(wildcard $(INCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%,$(OBJDIR)/% , $(patsubst %.c,%.o, $(SRCS)))


FLEX_GEN := $(INCDIR)/lex.yy.h $(AUXSRCDIR)/lex.yy.c
BISON_GEN := $(INCDIR)/y.tab.h $(AUXSRCDIR)/y.tab.c $(AUXSRCDIR)/y.output

BISON_FILE := alfa.y
FLEX_FILE := alfa.l


EXECUTABLE = alfa


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

$(AUXSRCDIR)/y.tab.c: $(BISON_FILE)
	@echo $(FMT_BOLD) "Generating y.yab.c" $(FMT_NORM)
	@bison -yv --defines=$(INCDIR)/y.tab.h -o $(AUXSRCDIR)/y.tab.c $^


$(AUXSRCDIR)/lex.yy.c: $(FLEX_FILE)
	@mkdir -p auxsrc
	@echo $(FMT_BOLD) "Generating lex.yy.c" $(FMT_NORM)
	@flex --header-file=$(INCDIR)/lex.yy.h -o $(AUXSRCDIR)/lex.yy.c $^ 


$(EXECUTABLE): $(AUXSRCDIR)/lex.yy.c $(AUXSRCDIR)/y.tab.c $(OBJS) 
	@echo $(FMT_BOLD) Generating $(EXECUTABLE) $(FMT_NORM)	
	$(CC) $(CFLAGS) $(INCFLAG) -o $(EXECUTABLE) $^


$(OBJDIR)/%.o: $(SRCDIR)/%.c  $(INCS) | $(OBJDIR) 
	@echo "$< -> $@"
	@$(CC) $(CFLAGS) $(INCFLAG) -c $< -o $@


BISON: 
	@bison -yv  --report=state --defines=$(INCDIR)/y.tab.h -o $(AUXSRCDIR)/y.tab.c $(BISON_FILE)

FLEX:
	@flex --header-file=$(INCDIR)/lex.yy.h -o $(AUXSRCDIR)/lex.yy.c $(FLEX_FILE) 


final: all clean pack

clean:
	$(RM) *~ $(EXECUTABLE)
	$(RM) -r $(FLEX_GEN) $(BISON_GEN)
	$(RM) -r $(OBJDIR)

pack:
	zip -r $(DELIVER)_tabla.zip . -i $(TOZIP)