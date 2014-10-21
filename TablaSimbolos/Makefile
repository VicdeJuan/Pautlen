CC = gcc
CFLAGS = -g -Wall
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

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR) depend
	@echo "$< -> $@"
	$(CC) $(CFLAGS) $(INCFLAG) -c $< -o $@


clean:
	$(RM) $(OBJDIR)/*.o *~ $(EXECUTABLE)

depend: $(SRCS)
	makedepend $(INCS) $^# DO NOT DELETE

includes/dictionary.o: includes/list_helpers.h
includes/list.o: /usr/include/stdlib.h /usr/include/features.h
includes/list.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
includes/list.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
includes/list.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
includes/list.o: /usr/include/endian.h /usr/include/bits/endian.h
includes/list.o: /usr/include/bits/byteswap.h /usr/include/bits/types.h
includes/list.o: /usr/include/bits/typesizes.h
includes/list.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
includes/list.o: /usr/include/time.h /usr/include/sys/select.h
includes/list.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
includes/list.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
includes/list.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
includes/list.o: /usr/include/bits/stdlib-float.h includes/errors.h
includes/list.o: includes/list_helpers.h
includes/symbol.o: includes/errors.h
includes/symbol_table.o: includes/symbol.h includes/dictionary.h
includes/symbol_table.o: includes/list_helpers.h
src/dictionary.o: includes/dictionary.h includes/list_helpers.h
src/dictionary.o: includes/errors.h /usr/include/string.h
src/dictionary.o: /usr/include/features.h /usr/include/stdc-predef.h
src/dictionary.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
src/dictionary.o: /usr/include/gnu/stubs.h /usr/include/xlocale.h
src/dictionary.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
src/dictionary.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
src/dictionary.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
src/dictionary.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/dictionary.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
src/dictionary.o: /usr/include/time.h /usr/include/sys/select.h
src/dictionary.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
src/dictionary.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
src/dictionary.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
src/dictionary.o: /usr/include/bits/stdlib-float.h
src/list.o: includes/errors.h /usr/include/strings.h /usr/include/features.h
src/list.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/list.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/list.o: /usr/include/xlocale.h includes/list_helpers.h
src/list_helpers.o: includes/list_helpers.h /usr/include/stdlib.h
src/list_helpers.o: /usr/include/features.h /usr/include/stdc-predef.h
src/list_helpers.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
src/list_helpers.o: /usr/include/gnu/stubs.h /usr/include/bits/waitflags.h
src/list_helpers.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
src/list_helpers.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
src/list_helpers.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/list_helpers.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
src/list_helpers.o: /usr/include/time.h /usr/include/sys/select.h
src/list_helpers.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
src/list_helpers.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
src/list_helpers.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
src/list_helpers.o: /usr/include/bits/stdlib-float.h /usr/include/string.h
src/list_helpers.o: /usr/include/xlocale.h
src/main.o: /usr/include/stdio.h /usr/include/features.h
src/main.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/main.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/main.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/main.o: /usr/include/libio.h /usr/include/_G_config.h
src/main.o: /usr/include/wchar.h /usr/include/bits/wchar.h
src/main.o: /usr/include/xlocale.h /usr/include/bits/stdio_lim.h
src/main.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
src/main.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
src/main.o: /usr/include/endian.h /usr/include/bits/endian.h
src/main.o: /usr/include/bits/byteswap.h /usr/include/bits/byteswap-16.h
src/main.o: /usr/include/sys/types.h /usr/include/time.h
src/main.o: /usr/include/sys/select.h /usr/include/bits/select.h
src/main.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
src/main.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
src/main.o: /usr/include/alloca.h /usr/include/bits/stdlib-float.h
src/symbol.o: includes/symbol.h /usr/include/stdlib.h /usr/include/features.h
src/symbol.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/symbol.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/symbol.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
src/symbol.o: /usr/include/endian.h /usr/include/bits/endian.h
src/symbol.o: /usr/include/bits/byteswap.h /usr/include/bits/types.h
src/symbol.o: /usr/include/bits/typesizes.h /usr/include/bits/byteswap-16.h
src/symbol.o: /usr/include/sys/types.h /usr/include/time.h
src/symbol.o: /usr/include/sys/select.h /usr/include/bits/select.h
src/symbol.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
src/symbol.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
src/symbol.o: /usr/include/alloca.h /usr/include/bits/stdlib-float.h
src/symbol_table.o: /usr/include/stdio.h /usr/include/features.h
src/symbol_table.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/symbol_table.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/symbol_table.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/symbol_table.o: /usr/include/libio.h /usr/include/_G_config.h
src/symbol_table.o: /usr/include/wchar.h /usr/include/bits/wchar.h
src/symbol_table.o: /usr/include/xlocale.h /usr/include/bits/stdio_lim.h
src/symbol_table.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
src/symbol_table.o: /usr/include/bits/waitflags.h
src/symbol_table.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
src/symbol_table.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
src/symbol_table.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
src/symbol_table.o: /usr/include/time.h /usr/include/sys/select.h
src/symbol_table.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
src/symbol_table.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
src/symbol_table.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
src/symbol_table.o: /usr/include/bits/stdlib-float.h
# DO NOT DELETE

includes/dictionary.o: includes/list_helpers.h
includes/list.o: /usr/include/stdlib.h /usr/include/features.h
includes/list.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
includes/list.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
includes/list.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
includes/list.o: /usr/include/endian.h /usr/include/bits/endian.h
includes/list.o: /usr/include/bits/byteswap.h /usr/include/bits/types.h
includes/list.o: /usr/include/bits/typesizes.h
includes/list.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
includes/list.o: /usr/include/time.h /usr/include/sys/select.h
includes/list.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
includes/list.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
includes/list.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
includes/list.o: /usr/include/bits/stdlib-float.h includes/errors.h
includes/list.o: includes/list_helpers.h
includes/symbol.o: includes/errors.h
includes/symbol_table.o: includes/symbol.h includes/dictionary.h
includes/symbol_table.o: includes/list_helpers.h
src/dictionary.o: includes/dictionary.h includes/list_helpers.h
src/dictionary.o: includes/errors.h /usr/include/string.h
src/dictionary.o: /usr/include/features.h /usr/include/stdc-predef.h
src/dictionary.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
src/dictionary.o: /usr/include/gnu/stubs.h /usr/include/xlocale.h
src/dictionary.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
src/dictionary.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
src/dictionary.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
src/dictionary.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/dictionary.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
src/dictionary.o: /usr/include/time.h /usr/include/sys/select.h
src/dictionary.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
src/dictionary.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
src/dictionary.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
src/dictionary.o: /usr/include/bits/stdlib-float.h
src/list.o: includes/errors.h /usr/include/strings.h /usr/include/features.h
src/list.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/list.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/list.o: /usr/include/xlocale.h includes/list_helpers.h
src/list_helpers.o: includes/list_helpers.h /usr/include/stdlib.h
src/list_helpers.o: /usr/include/features.h /usr/include/stdc-predef.h
src/list_helpers.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
src/list_helpers.o: /usr/include/gnu/stubs.h /usr/include/bits/waitflags.h
src/list_helpers.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
src/list_helpers.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
src/list_helpers.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/list_helpers.o: /usr/include/bits/byteswap-16.h /usr/include/sys/types.h
src/list_helpers.o: /usr/include/time.h /usr/include/sys/select.h
src/list_helpers.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
src/list_helpers.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
src/list_helpers.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
src/list_helpers.o: /usr/include/bits/stdlib-float.h /usr/include/string.h
src/list_helpers.o: /usr/include/xlocale.h
src/main.o: /usr/include/stdio.h /usr/include/features.h
src/main.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/main.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/main.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
src/main.o: /usr/include/libio.h /usr/include/_G_config.h
src/main.o: /usr/include/wchar.h /usr/include/bits/wchar.h
src/main.o: /usr/include/xlocale.h /usr/include/bits/stdio_lim.h
src/main.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
src/main.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
src/main.o: /usr/include/endian.h /usr/include/bits/endian.h
src/main.o: /usr/include/bits/byteswap.h /usr/include/bits/byteswap-16.h
src/main.o: /usr/include/sys/types.h /usr/include/time.h
src/main.o: /usr/include/sys/select.h /usr/include/bits/select.h
src/main.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
src/main.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
src/main.o: /usr/include/alloca.h /usr/include/bits/stdlib-float.h
src/symbol.o: includes/symbol.h /usr/include/stdlib.h /usr/include/features.h
src/symbol.o: /usr/include/stdc-predef.h /usr/include/sys/cdefs.h
src/symbol.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
src/symbol.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
src/symbol.o: /usr/include/endian.h /usr/include/bits/endian.h
src/symbol.o: /usr/include/bits/byteswap.h /usr/include/bits/types.h
src/symbol.o: /usr/include/bits/typesizes.h /usr/include/bits/byteswap-16.h
src/symbol.o: /usr/include/sys/types.h /usr/include/time.h
src/symbol.o: /usr/include/sys/select.h /usr/include/bits/select.h
src/symbol.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
src/symbol.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
src/symbol.o: /usr/include/alloca.h /usr/include/bits/stdlib-float.h
