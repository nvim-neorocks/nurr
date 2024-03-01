# Neovim User Rock Repository (NURR)

The NURR hosts and automatically packages Neovim Luarocks releases for many plugins
whose developers do not want to maintain a Luarocks CI workflow.

This repository contains a CI which runs every 4 hours, enumerating a set of curated Neovim plugins
and publishing them to the `neovim` manifest on `luarocks.org` - this keeps the root manifest clean
and allows the original authors to publish their own plugins if they so choose.
