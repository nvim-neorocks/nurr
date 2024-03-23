#!/usr/bin/env -S nvim -u NONE -U NONE -N -i NONE -l

vim.opt.rtp:append(vim.fs.joinpath(vim.fn.getcwd(), "nvim-treesitter"))

io.write(vim.json.encode(require('nvim-treesitter.parsers').configs))
