$(LUAC_T):
	$(ECHOT) CC $@
	$(HOST_CC) -o $@ -DMAKE_LUAC $(FLAGS) $(ONE).c -lm

$(LUA_T):
	$(ECHOT) CC $@
	$(HOST_CC) -o $@ -DMAKE_LUA -DLUA_USE_DLOPEN $(luaDEFINES) $(FLAGS) $(ONE).c -lm $(LUAT_FLAGS)

$(HOST_LUA_O):
	$(ECHOT) CC $@
	$(HOST_CC) -o $@ -c -Iaux -DMAKE_LIB $(luaDEFINES) -fPIC $(FLAGS) $(ONE).c

$(HOST_LUA_A): $(HOST_LUA_O)
	$(ECHOT) AR $@
	$(AR) $(ARFLAGS) $@ $< >/dev/null 2>&1
	$(RANLIB) $@

$(LUA_O):
	$(ECHOT) CC $@
	$(TARGET_DYNCC) -o $@ -c -Iaux -DMAKE_LIB $(luaDEFINES) $(TARGET_FLAGS) $(ONE).c

$(LUA_A): $(LUA_O)
	$(ECHOT) AR $@
	$(TARGET_AR) $(ARFLAGS) $@ $< >/dev/null 2>&1
	$(TARGET_RANLIB) $@

$(MODULES):
	$(ECHOT) CP MODULES
	for f in $(VENDOR); do $(CP) $(VENDOR_P)/$$f.lua .; done
	for f in $(SRC); do $(CP) $(SRC_P)/$$f.lua .; done

$(SRC_LUA):
	for d in $(SRC_DIRS); do [ -d $$d ] || $(CPR) $(SRC_P)/$$d .; done

$(VENDOR_LUA):
	for d in $(VENDOR_DIRS); do [ -d $$d ] || $(CPR) $(VENDOR_P)/$$d .; done

$(EXE_T): $(BUILD_DEPS) $(LIBLUA_A) $(LUA_T) $(C_MODULES) $(COMPILED) $(MODULES) $(SRC_LUA) $(VENDOR_LUA)
	$(ECHOT) LN $(EXE_T)
	CC=$(TARGET_STCC) NM=$(TARGET_NM) $(LUA_T) $(LUASTATIC) $(MAIN) \
	   $(SRC_LUA) $(VENDOR_LUA) $(MODULES) $(C_MODULES) $(LIBLUA_A) \
	   $(TARGET_FLAGS) $(PIE) $(TARGET_LDFLAGS) 2>&1 >/dev/null
	$(RM) $(RMFLAGS) $(MAIN).c $(MODULES)
	$(RMRF) $(VENDOR_DIRS) $(SRC_DIRS)

dev: $(LUA_T) $(C_SHARED) $(COMPILED) $(MODULES) $(SRC_LUA) $(VENDOR_LUA)
	bin/lua bin/luacheck.lua $(COMPILED) $(MODULES)

clean: $(CLEAN)
	$(ECHO) "Cleaning up..."
	$(RM) $(RMFLAGS) $(MAIN).c $(LUA_O) $(LUA_T) $(LUAC_T) $(LUA_A) $(EXE_T) \
	   $(HOST_LUA_A) $(HOST_LUA_O) $(COMPILED) $(MODULES)
	$(RMRF) $(SRC_DIRS) $(VENDOR_DIRS)
	$(RMRF) *.a
	$(ECHO) "Done!"

install: $(EXE_T)
	$(ECHO) "Installing..."
	$(INSTALL) -d $(PREFIX)/bin
	$(INSTALL) -c $(EXE_T) $(PREFIX)/$(EXE_T)
	$(ECHO) "Done!"

new:
	$(RMRF) vendor/lua/* vendor/c/* src/lua/* src/c/* \
		bin/test.moon bin/moonc.lua bin/moonpick.lua bin/moor.moon Makefile
	$(CP) aux/Makefile.pristine Makefile

