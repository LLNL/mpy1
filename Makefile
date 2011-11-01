# Makefile for MPY = Message Passing Yorick based on the MPI standard
# $Id: Makefile,v 1.1.1.1 2009-12-07 01:44:11 dhmunro Exp $

Y_MAKEDIR=
Y_EXE=
Y_EXE_PKGS=
Y_EXE_HOME=
Y_EXE_SITE=
Y_HOME_PKG=

# make PKG_SUFFIX=v1 to build mpy1 without mpy2 naming conflicts
# set by using make v1, v1install, v1uninstall targets below
PKG_SUFFIX=
Y_MAKEMPY=./Makempy$(PKG_SUFFIX)

# ----------------------------------------------------- optimization flags

COPT=$(COPT_DEFAULT)
#TGT=$(DEFAULT_TGT)
TGT=exe

# ------------------------------------------------ macros for this package

PKG_NAME=mpy$(PKG_SUFFIX)
PKG_I=$(PKG_NAME).i

OBJS=mpy.o

PKG_EXENAME=$(PKG_NAME)

# PKG_DEPLIBS=-Lsomedir -lsomelib   for dependencies of this package
PKG_DEPLIBS=
# set compiler flags specific to this package
PKG_CFLAGS=$(MPI_CFLAGS)
PKG_LDFLAGS=

EXTRA_PKGS=$(Y_EXE_PKGS)

PKG_CLEAN=

PKG_I_START=
PKG_I_EXTRA=testmp$(PKG_SUFFIX).i

# -------------------------------- standard targets and rules (in Makepkg)

# set macros Makepkg uses in target and dependency names
# DLL_TARGETS, LIB_TARGETS, EXE_TARGETS
# are any additional targets (defined below) prerequisite to
# the plugin library, archive library, and executable, respectively
PKG_I_DEPS=$(PKG_I)
Y_DISTMAKE=distmake

include $(Y_MAKEDIR)/Make.cfg
include $(Y_MAKEDIR)/Makepkg
include $(Y_MAKEDIR)/Make$(TGT)

# override macros Makepkg sets for rules and other macros

# this overrides CC and FC macros, provides MPI_CFLAGS
include $(Y_MAKEMPY)

# above appropriate for TGT=dll, below because this is TGT=exe
Y_BINDIR=$(Y_EXE_HOME)/bin
Y_LIBEXE=$(Y_EXE_HOME)/lib
Y_INCLUDE=$(Y_EXE_HOME)/include
DEST_Y_SITE=$(DESTDIR)$(Y_EXE_SITE)
DEST_Y_HOME=$(DESTDIR)$(Y_EXE_HOME)

# reduce chance of yorick-1.5 corrupting this Makefile
MAKE_TEMPLATE = /usr/lib/yorick/1.5/protect-against-1.5

# ------------------------------------- targets and rules for this package

install:: Makempy$(PKG_SUFFIX)
	$(YNSTALL) Makempy$(PKG_SUFFIX) "$(DEST_Y_HOME)"

uninstall::
	rm -f "$(DEST_Y_HOME)/Makempy$(PKG_SUFFIX)"

distclean::
	rm -f Makempy

v1: Makempyv1 mpyv1.i testmpv1.i
	$(MAKE) PKG_SUFFIX=v1
v1install: Makempyv1 mpyv1.i testmpv1.i
	$(MAKE) PKG_SUFFIX=v1 install
v1uninstall:
	$(MAKE) PKG_SUFFIX=v1 uninstall

Makempyv1: Makempy
	cp Makempy Makempyv1
mpyv1.i: mpy.i
	cp mpy.i mpyv1.i
testmpv1.i: testmp.i
	cp testmp.i testmpv1.i

clean::
	rm -f mpyv1.i testmpv1.i libmpyv1.a mpyv1 libmpy.a mpy
distclean::
	rm -f Makempyv1

# -------------------------------------------------------- end of Makefile
