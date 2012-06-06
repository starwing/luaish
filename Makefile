EXE = .exe
target = luaish$(EXE)
objs = objs/luaish.o objs/scripts.o objs/linenoise.o objs/linenoiselib.o objs/lpath.o

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
	-$(RM) -fr objs $(target) src/main_squished.lua src/scripts.c

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

src/scripts.c : src/main_squished.lua
	$(LUA) src/bin2c.lua -n main_squished_lua -o $@ $<

src/main_squished.lua :
	cd src && $(LUA) squish.lua
