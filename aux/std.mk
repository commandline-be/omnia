EXE_T:= bin/$(EXE)
MAIN:= $(EXE_T).lua
ONE:= aux/one
LUASTATIC:= bin/luastatic.lua
LUAC_T:= bin/luac
LUA_O:= one.o
LUA_A:= liblua.a
HOST_LUA_O:= host_one.o
HOST_LUA_A:= host_liblua.a
LUA_T:= bin/lua
LUACFLAGS?= -s
ECHO:= @printf '%s\n'
ECHON:= @printf '%s'
ECHOT:= @printf ' %s\t%s\n'
CP:= cp
CPR:= cp -R
STRIPFLAGS:= --strip-all
RM:= rm
RMFLAGS:= -f
RMRF:= rm -rf
VENDOR_P:= vendor/lua
SRC_P:= src/lua
VENDOR_LUA:= $(addsuffix /*.lua,$(VENDOR_DIR))
SRC_LUA:= $(addsuffix /*.lua,$(SRC_DIR))
VENDOR_DIRS:= $(foreach f, $(VENDOR_DIR), $(firstword $(subst /, ,$f)))
SRC_DIRS:= $(foreach f, $(SRC_DIR), $(firstword $(subst /, ,$f)))
_rest= $(wordlist 2,$(words $(1)),$(1))
_lget= $(firstword src/c/$(1))/Makefile $(if $(_rest),$(call _lget,$(_rest)),)
_vget= $(firstword vendor/c/$(1))/Makefile $(if $(_rest),$(call _vget,$(_rest)),)
MODULES+= $(foreach m, $(VENDOR), $m.lua)
MODULES+= $(foreach m, $(SRC), $m.lua)
SRC_MOON:= $(wildcard bin/*.moon)
SRC_MOON+= $(wildcard src/lua/*.moon)
SRC_MOON+= $(wildcard vendor/lua/*.moon)
SRC_MOON+= $(foreach m, $(SRC_DIR), $(wildcard src/lua/$m/*.moon))
SRC_MOON+= $(foreach m, $(VENDOR_DIR), $(wildcard vendor/lua/$m/*.moon))
COMPILED:= $(foreach m, $(SRC_MOON), $(addsuffix .lua, $(basename $m)))
C_MODULES+= $(foreach m, $(VENDOR_C), $m.a)
C_MODULES+= $(foreach m, $(SRC_C), $m.a)
BUILD_DEPS= has-$(TARGET_STCC) has-$(TARGET_RANLIB) has-$(TARGET_NM) has-$(TARGET_AR) has-$(TARGET_STRIP)

all: $(EXE_T)

ifeq ($(filter lpeg,$(VENDOR_C)),)
  include vendor/c/lpeg/Makefile
endif

ifneq ($(SRC_MOON),)
  include aux/moonscript.mk
endif

ifneq ($(SRC_C),)
  include $(eval _d:=src/c/$(SRC_C) $(_d)) $(call _lget,$(SRC_C))
endif

ifneq ($(VENDOR_C),)
  include $(eval _d:=vendor/c/$(VENDOR_C) $(_d)) $(call _vget,$(VENDOR_C))
endif

print-%: ; @echo $*=$($*)

vprint-%:
	@echo '$*=$($*)'
	@echo ' origin = $(origin $*)'
	@echo ' flavor = $(flavor $*)'
	@echo ' value = $(value $*)'

has-%:
	@command -v "${*}" >/dev/null 2>&1 || { \
		echo "Missing build-time dependency: ${*}"; \
		exit -1; \
	}

.PHONY: all new clean print-% vprint-% has-%
