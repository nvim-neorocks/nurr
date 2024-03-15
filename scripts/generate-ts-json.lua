#!/usr/bin/env -S nvim -u NONE -U NONE -N -i NONE -l

local home = vim.uv.os_getenv('HOME')

local sc = vim.system({ "luarocks", "install", "--local", "--server='https://luarocks.org/manifests/neorocks'", "nvim-treesitter", "scm"}):wait()

if sc.code ~= 0 then
  error("Failed to install nvim-treesitter: " .. sc.stderr .. "\n" .. sc.stdout)
end

local luarocks_path = {
    vim.fs.joinpath(home, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(home, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

local luarocks_cpath = {
    vim.fs.joinpath(home, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(home, "lib64", "lua", "5.1", "?.so"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

io.write(vim.json.encode(require('nvim-treesitter.parsers').configs))
