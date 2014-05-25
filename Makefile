##############################################################################
## Source-level Makefile for jzintv
##
## The whole make process is driven from the top-level Makefile.  In contrast
## to the (poor) advice given in the Make documentation, I do _not_ call make
## recursively to build the source of this project.
##############################################################################

##############################################################################
## Project directory structure
##############################################################################
B=../bin
L=../lib
R=../rom

##############################################################################
## Project-wide build flags
##############################################################################
P           = export PATH;

SDL_CFLAGS := $(shell sdl-config --cflags)
SDL_LFLAGS := $(shell sdl-config --libs) 

# Set "X" to be the executable extension
X =        

# Set "RM" to be the remove/delete command
RM = rm -f 

 WARN    = -Wall -W -Wshadow -Wpointer-arith 				\
	       -Wbad-function-cast -Wcast-qual -Wc++-compat		\
		   -Wmissing-declarations -Wmissing-prototypes 		\
		   -Wstrict-prototypes
 WARNXX  = -Wall -W -Wshadow -Wpointer-arith -Wcast-qual 


#WARN    = -W -Wall -ansi -Wbad-function-cast -Wcast-align \
		   -Wcast-qual -Wchar-subscripts -Winline \
		   -Wmissing-prototypes -Wnested-externs -Wpointer-arith \
		   -Wshadow -Wstrict-prototypes -Wwrite-strings \
	   -Dlinux

#WARNXX  = -W -Wall -ansi -Wcast-align \
 		   -Wcast-qual -Wchar-subscripts -Winline \
 		   -Wpointer-arith -Wredundant-decls -Wshadow -Wwrite-strings \
 	   -Dlinux


 CC  = $(P) gcc -std=c99
 CXX = $(P) g++
#CC  = $(P) gcc-3.4
#CC  = $(P) /usr/local/bin/gcc -V4.1.1
#CXX = $(P) /usr/local/bin/g++ 
#CC  = $(P) icc
#CC  = $(P) /usr/bin/gcc
#CXX = $(P) /usr/bin/g++

#DEF_FLAGS += -DDIRECT_INTV2PC
#DEF_FLAGS += -DNEED_INOUT
 DEF_FLAGS += -Dlinux

#OPT_FLAGS = -ggdb3
#OPT_FLAGS = -O
#OPT_FLAGS = -O2 -ggdb3
 OPT_FLAGS = -O6 -fomit-frame-pointer -fprefetch-loop-arrays -msse #-DBENCHMARK_STIC
#OPT_FLAGS = -O2 -pg -ggdb -DLOCAL=
#OPT_FLAGS = -tpp6 -axMiKW -ip -vec_report3 -opt_report -ansi_alias -restrict -DHAVE_RESTRICT -align -O3 -Ob1 # -ipo # intel icc flags

CFLAGS   = $(OPT_FLAGS) $(WARN)   -I. -I.. $(DEF_FLAGS) $(EXTRA)
CXXFLAGS = $(OPT_FLAGS) $(WARNXX) -I. -I.. $(DEF_FLAGS) $(EXTRA)
#LFLAGS   = /usr/local/lib/libgcc_s.so -L../lib 
LFLAGS   = -L../lib


OBJS=jzintv.o
PROG=$(B)/jzintv
TOCLEAN=$(B)/jzintv core

#PROGS=$(PROG)

CFLAGS += $(SDL_CFLAGS) 
#LFLAGS += $(SDL_LFLAGS)

##############################################################################
## Generic build-rules
##############################################################################

all: $(OBJS) $(PROG)

$(PROG): $(OBJS)
	$(CC) -o $(PROG) $(OBJS) $(CFLAGS) $(LFLAGS) $(SDL_LFLAGS)

clean:
	$(RM) $(OBJS) 
	$(RM) $(TOCLEAN)

%.o: %.c
	$(CC) -o $@ $(CFLAGS) -c $<

%.s: %.c
	$(CC) -fverbose-asm -S -o $@ $(CFLAGS) -c $<

##############################################################################
## Linux-specific stuff
##############################################################################

pads/pads_intv2pc.o:
	$(CC) -O6 -o pads/pads_intv2pc.o $(CFLAGS) -c pads/pads_intv2pc.c

OBJS += pads/pads_cgc_linux.o
OBJS += pads/pads_intv2pc.o

##############################################################################
## Makefile.common includes all the subMakefiles and such
##############################################################################
include Makefile.common
build: jzIntv SDK-1600
