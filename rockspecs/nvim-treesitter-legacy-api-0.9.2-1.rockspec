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

- plugin
- autoload
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
}
