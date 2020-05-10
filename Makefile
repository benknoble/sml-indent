.POSIX:
SHELL = /bin/sh
.SUFFIXES:

RM = rm -f
SED = sed
INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

prefix = /usr/local
exec_prefix = $(prefix)
# for user programs
bindir = $(exec_prefix)/bin

# for object files and libraries of object code
libdir = $(exec_prefix)/lib

# easiest to build with
# eval export $(.arch-n-opsys | sed 's/;//g')
# make ...

TARGET = indent
CM = sources.cm
MAIN = Main.main
SOURCE = indent.lex indent.sml run.sml sources.cm sym.sml test.sml util.sml

BUILD = ml-build
HEAP = $(TARGET).$(ARCH)-$(OPSYS)

all: $(TARGET)

$(TARGET): $(HEAP)
	printf '%s\n' '#! /bin/sh' 'exec sml @SMLload="$^" "$$@"' > "$@"
	chmod u+x "$@"

$(HEAP): $(CM) $(SOURCE)
	$(BUILD) $(BUILDFLAGS) $(CM) $(MAIN) $(TARGET)

install: $(TARGET) $(HEAP)
	<$(TARGET) $(SED) 's:$(HEAP):$(DESTDIR)$(libdir)/&:' >$(TARGET).tmp
	$(INSTALL_PROGRAM) $(TARGET).tmp $(DESTDIR)$(bindir)/$(TARGET)
	$(RM) $(TARGET).tmp
	$(INSTALL_DATA) $(HEAP) $(DESTDIR)$(libdir)

uninstall:
	-$(RM) $(DESTDIR)$(bindir)/$(TARGET)
	-$(RM) $(DESTDIR)$(libdir)/$(HEAP)

clean:
	-$(RM) $(HEAP) $(TARGET)
	-$(RM) indent.lex.sml
	-$(RM) -r .cm
