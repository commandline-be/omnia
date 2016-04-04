Omnia
=====

Another Lua 5.3 build system for standalone executables. My main use case is for ELF platforms and statically linking with [musl libc](http://www.musl-libc.org/).

This was made possible by [luastatic](https://github.com/ers35/luastatic)

Similar projects:<br>
[LuaDist](http://luadist.org/)<br/>
[luabuild](https://github.com/stevedonovan/luabuild)

Requires: Developement tools e.g. build-essential<br/>
Note: Linux only. xBSD soon.

#### Getting started

1. Edit the following variables in the top-level Makefile<br/>
     MAIN: Path to the "main" Lua script<br/>
     VENDOR_C: Space delimited string of C modules<br/>
     VENDOR_LUA: Space delimited string of Lua modules<br/>

1. Run `make`<br/>
If you want to link statically run `make STATIC=1`

#### Adding modules

Adding plain Lua modules is trivial. $(NAME) is the name of the module passed to `VENDOR_LUA`.

1. Copy the Lua module to `vendor/modules/$(NAME).lua`<br/>
  example: `cp ~/Downloads/dkjson.lua vendor/modules`
1. Add `$(NAME)` to `VENDOR_LUA`<br/>
  example: `VENDOR_LUA= re dkjson`

C modules are a bit more complicated.

1. Provide a Makefile in `vendor/$(NAME)/Makefile`
1. Add `$(NAME)` to `VENDOR_C`

#### Included projects

Project                                                     | Version         | License
------------------------------------------------------------|-----------------|---------
[Lua](http://www.lua.org)                                   | 5.3.1           | MIT
[Luawrapper](https://github.com/ncarrier/luawrapper)[1]     | 0.2.1           | MIT
[ELF Tool Chain/libelf](https://wiki.freebsd.org/LibElf)[2] | SVN r3177       | BSD
[luastatic](https://github.com/ers35/luastatic)             | 0ef44ef         | CC0

#### Available modules

Module                                                      | Version         | License
------------------------------------------------------------|-----------------|---------
[Luaposix](https://github.com/luaposix/luaposix)[1]         | 33.3.1          | MIT
[Linotify](https://github.com/hoelzro/linotify)             | 0.4             | MIT
[LPeg](http://www.inf.puc-rio.br/~roberto/lpeg/)            | 0.12.2          | MIT
[lsocket](http://tset.de/lsocket/)[2]                       | 1.4             | MIT

[1] Curses not included. posix.deprecated and posix.compat removed<br/>
[2] Does not include the async resolver<br/>

