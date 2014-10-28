CC = gcc
CFLAGS = -g -Wall -pedantic -std=c99 -ggdb
INCFLAG = -I./includes

OBJDIR = obj
SRCDIR = src
INCDIR = includes

INCS := $(wildcard $(INCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%,$(OBJDIR)/% , $(patsubst %.c,%.o, $(SRCS)))

EXECUTABLE = pruebaMorfo

GROUP = 1401
LAST = dejuan_Sanz
NAME = Victor
DELIVER = $(GROUP)_$(LAST)_$(NAME)
TOZIP = $(DELIVER)/src $(DELIVER)/includes $(DELIVER)/Makefile

.PHONY: depend clean pack final

all:	$(EXECUTABLE)

$(OBJDIR):
	@echo Creating obj directory
	@mkdir -p $(OBJDIR)

$(EXECUTABLE): $(OBJS) 
	@flex rules.l
	$(CC) $(CFLAGS) $(INCFLAG) -o $(EXECUTABLE) $(OBJS) $(LFLAGS) $(LIBS) lex.yy.c


$(OBJDIR)/%.o: $(SRCDIR)/%.c  $(INCS) | $(OBJDIR) 
	@echo "$< -> $@"
	@$(CC) $(CFLAGS) $(INCFLAG) -c $< -o $@

final: all clean pack

clean:
	$(RM) *~ $(EXECUTABLE)
	$(RM) -r $(OBJDIR)

pack:
	zip -r $(DELIVER)_tabla.zip . -i $(TOZIP)