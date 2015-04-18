TESTLOG_F = test.log
AUX_P = aux
LUAC_T= bin/luac
LUAC2C_T= bin/luac2c
LUA_O= aux/one.o
LUAWRAPPER= -Lvendor/luawrapper -lluawrapper -Lvendor/libelf -lelf
LUA_T= bin/lua
ONE= $(AUX_P)/one
LUACFLAGS?= -s
ECHO = @printf '%s\n'
ECHON = @printf '%s'
ECHOT = @printf ' %s\t%s\n'
M4 = m4
UPX= upx
UPXFLAGS= --best --ultra-brute
STRIP = strip
STRIPFLAGS= --strip-all
OBJCOPY= objcopy
OBJCOPYA= @objcopy --add-section lw_
RM= rm
RMFLAGS= -f
RMRF= rm -rf
CP= @cp

_rest= $(wordlist 2,$(words $(1)),$(1))
_lget= $(firstword lib/$(1))/Makefile $(if $(_rest),$(call _lget,$(_rest)),)
_vget= $(firstword vendor/$(1))/Makefile $(if $(_rest),$(call _vget,$(_rest)),)
SRC_P= vendor/lua
INCLUDES:= -I$(SRC_P) -Iinclude -I$(AUX_P)
LDLIBS+= $(foreach m, $(LIB), -Llib/$m -l$m)
LDLIBS+= $(foreach m, $(VENDOR_C), -Lvendor/$m -l$m)
LDEFINES+= $(foreach d, $(LIB) $(VENDOR_C), -Dlib_$d)
BUILD_DEPS = has-$(CC) has-$(RANLIB) has-$(LD) has-$(AR) has-$(OBJCOPY) has-$(M4) has-$(STRIP) has-$(RM)