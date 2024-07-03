local modrev = 'scm'
local specrev = '-1'

rockspec_format = '3.0'
package = 'nvim-treesitter'
version = modrev .. specrev

description = {
  summary = 'Nvim Treesitter configurations and abstraction layer (main)',
  labels = { 'neovim' },
  homepage = 'https://github.com/nvim-treesitter/nvim-treesitter',
  license = 'Apache-2.0',
}

dependencies = {
  'lua >= 5.1',
}

source = {
  url = 'git+https://github.com/nvim-treesitter/nvim-treesitter',
  branch = 'main',
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
  copy_directories = {
    'doc',
    'plugin',
    'runtime/queries',
  },
  patches = {
    ["makefile.diff"] = [[
new file mode 100644
index 00000000..5c1d843f
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,6 @@
+build: 
+	echo "Do nothing"
+
+install:
+	mkdir -p $(INST_LUADIR)
+	cp -r lua/* $(INST_LUADIR)
]]
  },
}
