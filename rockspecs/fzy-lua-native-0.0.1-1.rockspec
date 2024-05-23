local modrev = '0.0.1'
local specrev = '-1'

rockspec_format = '3.0'
package = 'fzy-lua-native'
version = modrev .. specrev

description = {
  summary = 'Luajit FFI bindings to FZY',
  labels = { 'fzy', 'ffi' },
  homepage = 'https://github.com/romgrk/fzy-lua-native',
  license = 'unknown',
}

dependencies = {
  'lua == 5.1',
}

source = {
  url = 'https://github.com/romgrk/fzy-lua-native/archive/820f745b7c442176bcc243e8f38ef4b985febfaf.zip',
  dir = 'fzy-lua-native-820f745b7c442176bcc243e8f38ef4b985febfaf',
}

build = {
  type = 'make',
  build_pass = false,
  install_variables = {
    INST_PREFIX='$(PREFIX)',
    INST_BINDIR='$(BINDIR)',
    INST_LIBDIR='$(LIBDIR)',
    INST_LUADIR='$(LUADIR)',
    INST_CONFDIR='$(CONFDIR)',
  },
  patches = {
    ["makefile.diff"] = [[
index f4f507e..568c594 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,10 @@ all:
 	$(CC) $(CFLAGS) -Ofast -c -Wall -static -fpic -o ./src/match.o ./src/match.c
 	$(CC) $(CFLAGS) -shared -o ./static/libfzy-$(OS)-$(ARCH).so ./src/match.o
 
+install:
+	mkdir -p $(INST_LUADIR)
+	cp -r lua/* $(INST_LUADIR)
+	cp -r static/* $(INST_LIBDIR)
 
 # vim:ft=make
 #
]],
		["native.diff"] = [[
index 96e393d..4971a29 100644
--- a/lua/native.lua
+++ b/lua/native.lua
@@ -28,8 +28,11 @@ local arch = (arch_aliases[jit.arch:lower()] or jit.arch:lower())
 
 
 -- ffi.load() doesn't respect anything but the actual path OR a system library path
-local dirname = string.sub(debug.getinfo(1).source, 2, string.len('/native.lua') * -1)
-local library_path = dirname .. '../static/libfzy-' .. os .. '-' .. arch .. '.so'
+local library_path = package.searchpath('libfzy-' .. os .. '-' .. arch, package.cpath)
+if not library_path then
+  local dirname = string.sub(debug.getinfo(1).source, 2, string.len('/native.lua') * -1)
+  library_path = dirname .. '../static/libfzy-' .. os .. '-' .. arch .. '.so'
+end
 
 local native = ffi.load(library_path)
 
]],
  },
}
