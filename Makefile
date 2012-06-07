EXE = .exe
target = luaish$(EXE)
objs = objs/luaish.o objs/scripts.o objs/linenoise.o objs/linenoiselib.o objs/lpath.o
luafiles = lua.lua luaish.lua externals/ml/ml.lua

LUADIR = d:/lua52
LUA_V = lua52
LUA = lua
PLAT = generic

CC = gcc
LD = gcc
CP = cp
RM = rm

CFLAGS = -O2 -Wall -I$(LUADIR)/include -DLUA_BUILD_AS_DLL $(MYCFLAGS)
LIBS = $(LUADIR)/lua52.dll

$(target) : objs $(objs)
	$(LD) $(LDFLAGS) -o $(target) $(objs) $(LIBS)

clean:
	-$(RM) -fr objs $(target) src/scripts.c

objs:
	mkdir objs

objs/luaish.o : src/luaish.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/linenoise.o : externals/linenoise/linenoise.c externals/linenoise/linenoise.h
	$(CC) $(CFLAGS) -c -o $@ $<

objs/linenoiselib.o : externals/linenoise/linenoiselib.c externals/linenoise/linenoise.h
	$(CC) $(CFLAGS) -c -o $@ $<

objs/lpath.o : externals/lpath/lpath.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/scripts.o : src/scripts.c
	$(CC) $(CFLAGS) -c -o $@ $<

src/scripts.c : src/bin2c.lua $(luafiles)
	$(LUA) src/bin2c.lua -g -o $@ $(luafiles)
