local modrev = 'scm'
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
  homepage = 'https://github.com/nvim-treesitter/nvim-treesitter/tree/master',
  license = 'Apache-2.0',
}

dependencies = {
  'lua >= 5.1',
}

source = {
  url = 'git+https://github.com/nvim-treesitter/nvim-treesitter.git',
  branch = 'master',
}

build = {
  type = 'builtin',
  copy_directories = {
    'plugin',
    'autoload',
    'doc',
  },
}
