local git_ref = 'v0.9.2'
local modrev = '0.9.2'
local specrev = '-1'

local repo_url = 'https://github.com/nvim-treesitter/nvim-treesitter'

rockspec_format = '3.0'
package = 'nvim-treesitter-legacy-api'
version = modrev .. specrev

description = {
  summary = 'nvim-treesitter legacy lua API',
  detailed = [[
nvim-treesitter is getting rid of the legacy module system, and is no longer
meant to be used as a dependency by other plugins.
Many plugins have not updated yet, and this package serves as a dependency for those plugins.

It does not include any of the following nvim-treesitter runtime directories:

- queries
- parser

WARNING: If you use nvim-treesitter, this plugin may cause conflicts.
If you use rocks.nvim, consider using rocks-treesitter.nvim and/or
tree-sitter-<lang> parser packages instead of nvim-treesitter.
]],
  labels = { 'neovim' },
  homepage = 'https://github.com/nvim-treesitter/nvim-treesitter/tree/v0.9.2',
  license = 'Apache-2.0',
}

dependencies = {
  'lua >= 5.1',
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'nvim-treesitter-' .. modrev,
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
    'plugin',
    'autoload',
    'doc',
  },
  patches = {
    ['nvim-treesitter.patch'] = [==[
diff --git a/lua/nvim-treesitter.lua b/lua/nvim-treesitter.lua
index 963fe730..fc69cdc2 100644
--- a/lua/nvim-treesitter.lua
+++ b/lua/nvim-treesitter.lua
@@ -10,9 +10,6 @@ require "nvim-treesitter.query_predicates"
 local M = {}
 
 function M.setup()
-  utils.setup_commands("install", install.commands)
-  utils.setup_commands("info", info.commands)
-  utils.setup_commands("configs", configs.commands)
   configs.init()
 end
 
diff --git a/plugin/nvim-treesitter.lua b/plugin/nvim-treesitter.lua
index 4ea3925f..70290bd2 100644
--- a/plugin/nvim-treesitter.lua
+++ b/plugin/nvim-treesitter.lua
@@ -7,28 +7,3 @@ vim.g.loaded_nvim_treesitter = true
 
 -- setup modules
 require("nvim-treesitter").setup()
-
-local api = vim.api
-
--- define autocommands
-local augroup = api.nvim_create_augroup("NvimTreesitter", {})
-
-api.nvim_create_autocmd("Filetype", {
-  pattern = "query",
-  group = augroup,
-  callback = function()
-    api.nvim_clear_autocmds {
-      group = augroup,
-      event = "BufWritePost",
-    }
-    api.nvim_create_autocmd("BufWritePost", {
-      group = augroup,
-      buffer = 0,
-      callback = function(opts)
-        require("nvim-treesitter.query").invalidate_query_file(opts.file)
-      end,
-      desc = "Invalidate query file",
-    })
-  end,
-  desc = "Reload query",
-})
]==]
  },
}
