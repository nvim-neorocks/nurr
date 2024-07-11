# Neovim User Rock Repository (NURR)

The NURR hosts and automatically packages Neovim Luarocks releases for many plugins
and tree-sitter parsers whose developers do not want to maintain a Luarocks CI workflow.

This repository contains a CI which runs periodically, enumerating a set of curated Neovim plugins
and publishing them to `luarocks.org`.

<!-- FIXME: -->
<!-- the `neovim` manifest on `luarocks.org` - this keeps the root manifest clean -->
<!-- and allows the original authors to publish their own plugins if they so choose. -->

## How it works

Plugins are published using the [luarocks-tag-release](https://github.com/nvim-neorocks/luarocks-tag-release)
action.

### Plugins

The plugin metadata are stored in a [plugins.json](./plugins.json) file, which
is currently updated manually.
A [chunk workflow](./.github/workflows/chunk.yml) reads the plugins.json file and 
chunks the plugins into sets of 256 (the max number of outputs per job).
Each chunk is dispatched to an update workflow, 
which uses the chunk it receives as the input for a matrix build.

> [!NOTE]
>
> Neovim plugins are published every 4 hours.

> [!IMPORTANT]
>
> When adding a plugin that claims it depends on nvim-treesitter,
> check if it actually does. Many plugins only depend on the parsers.
> If it does, we recommend:
>
> - Adding `nvim-treesitter-legacy-api` to the dependencies
>   (this does not clash with the luarocks tree-sitter parsers' queries).
> - Opening a PR or an issue to use Neovim's core API instead.

#### Schema

- `name`: owner/repo (GitHub)
- `shorthand`: The name of the plugin (will be the lua rock name)
- `dependencies`: Plugin dependencies, a list of luarocks plugins
- `summary`: Short description of the plugin
- `license`: The license SPDX
- `extra_directories`: (optional) Extra directories to copy, separated by `\n`,
  in addition to the standard Neovim runtime directories, which are auto-detected.

### Tree-sitter parsers [WIP]

- One workflow periodically generates the [tree-sitter-parsers.json](./tree-sitter-parsers.json)
  file, using nvim-treesitter as a source.
- Another workflow uses that file as a matrix input, to generate
  rockspecs (that use [`luarocks-build-tree-sitter-parser`](https://github.com/nvim-neorocks/luarocks-build-treesitter-parser))
  and publishes them to luarocks.org.

> [!NOTE]
>
> Tree-sitter parsers are published every 7 hours.

> [!IMPORTANT]
>
> Any tree-sitter parser rockspecs that cannot be built and installed by the workflow

> are not uploaded to luarocks.org.
