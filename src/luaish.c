/* Include the Lua API header files. */
#define LUA_LIB
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

LUALIB_API int luaopen_path      (lua_State *L);
LUALIB_API int luaopen_linenoise (lua_State *L);
LUALIB_API int luaopen_luaish    (lua_State *L);
LUALIB_API int luaopen_ml        (lua_State *L);
LUALIB_API int luaopen_lua       (lua_State *L);

int main( int argc, char *argv[] )
{
    int i;
    lua_State *L = luaL_newstate();

    /* load the libs */
    luaL_openlibs(L);
    lua_getfield(L, LUA_REGISTRYINDEX, "_PRELOAD");
    lua_pushcfunction(L, luaopen_path);
    lua_setfield(L, -2, "path");
    lua_pushcfunction(L, luaopen_linenoise);
    lua_setfield(L, -2, "linenoise");
    lua_pushcfunction(L, luaopen_ml);
    lua_setfield(L, -2, "ml");
    lua_pushcfunction(L, luaopen_luaish);
    lua_setfield(L, -2, "luaish");
    lua_settop(L, 0);

    /* command line args */
    if (argc > 0) {
      for (i = 1; i < argc; i++)
        lua_pushstring(L, argv[i]);
    }
    lua_newtable(L);
    if (argc > 0) {
        for (i = 1; i < argc; i++) {
            lua_pushvalue(L, i);
            lua_rawseti(L, -2, i);
        }
    }
    lua_setglobal(L, "arg");

    lua_pushcfunction(L, luaopen_lua);
    lua_insert(L, 1);

    /* push debug.traceback */
    lua_getglobal(L, LUA_DBLIBNAME);
    lua_getfield(L, -1, "traceback");
    lua_remove(L, -2);
    lua_insert(L, 1);

    if (lua_pcall(L, lua_gettop(L) - 2, 0, 1) != 0) {
        puts(lua_tostring(L, -1));
        return 2;
    }

    lua_close(L);

    return 0;
}
/* cc: flags+='-Id:/lua51/include' */
