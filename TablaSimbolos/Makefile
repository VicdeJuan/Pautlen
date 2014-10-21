CC = gcc
CFLAGS = -g 
INCFLAG = -I./includes

OBJDIR = obj
SRCDIR = src
INCDIR = includes

INCS := $(wildcard $(INCDIR)/*.h)
SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%,$(OBJDIR)/% , $(patsubst %.c,%.o, $(SRCS)))

EXECUTABLE = tabla_pruebas


.PHONY: depend clean

all:	$(EXECUTABLE)

$(EXECUTABLE): $(OBJS) 
	$(CC) $(CFLAGS) $(INCS) -o $(EXECUTABLE) $(OBJS) $(LFLAGS) $(LIBS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR) 
	#depend
	@echo "$< -> $@"
	$(CC) $(CFLAGS) $(INCFLAG) -c $< -o $@


clean:
	$(RM) $(OBJDIR)/*.o *~ $(EXECUTABLE)



#depend: $(SRCS)
#	makedepend $(INCS) $^# DO NOT DELETE