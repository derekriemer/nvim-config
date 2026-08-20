# Neovim Config Setup

Personal Neovim configuration. The config bootstraps `lazy.nvim`, installs Lazy-managed plugins from `lua/plugins`, and uses Mason for language servers.

## Prerequisites

Install these before starting Neovim on a new machine:

- Neovim 0.11 or newer.
- `git`, used by `lazy.nvim` to clone plugins.
- `bash`, because `lua/config/options.lua` sets `vim.opt.shell = "bash"` on non-Windows systems.
- `rg` / ripgrep, used by Snacks picker grep.
- `tree-sitter` CLI, used by `nvim-treesitter` to install parsers.
- A C/C++ build toolchain, needed by native plugin/parser builds.
- Language runtimes and package managers for the languages you want LSP support for:
  - Node.js/npm for TypeScript, JavaScript, and pyright installation paths.
  - Python for Python projects.
  - Rust toolchain for Rust projects.
  - JDK for Kotlin projects.

Example Ubuntu-ish baseline:

```sh
sudo apt install git bash ripgrep build-essential nodejs npm python3 python3-venv cargo openjdk-21-jdk
cargo install tree-sitter-cli
```

Adjust package names for the distro or package manager on the target machine.

## Install the Config

Clone this repo into Neovim's config directory:

```sh
git clone <repo-url> ~/.config/nvim
nvim
```

On first launch, `lua/config/lazy.lua` clones `lazy.nvim` into Neovim's data directory and installs the configured plugins. After startup, run:

```vim
:Lazy sync
:Mason
:checkhealth
```

The lockfile pins Lazy-managed plugins in `lazy-lock.json`.

## Lazy Plugins

The current Lazy-managed plugin set is:

- `saghen/blink.cmp`
- `saghen/blink.lib`
- `folke/snacks.nvim`
- `folke/which-key.nvim`
- `kylechui/nvim-surround`
- `neovim/nvim-lspconfig`
- `williamboman/mason.nvim`
- `williamboman/mason-lspconfig.nvim`
- `nvim-treesitter/nvim-treesitter`
- `nvim-treesitter/nvim-treesitter-textobjects`
- `kevinhwang91/nvim-ufo`
- `kevinhwang91/promise-async`

`blink.cmp` has a custom native build hook. If it fails during install, verify that Neovim can start cleanly and that the machine has a working compiler/toolchain.

## Mason Language Servers

`lua/plugins/lsp.lua` asks Mason to install and enable:

- `kotlin_lsp` (Mason package: `kotlin-lsp`)
- `lua_ls`
- `rust_analyzer`
- `ts_ls`
- `pyright`

Mason installs the servers, but project-specific tooling still needs to exist separately when you work in those projects, such as a JDK for Kotlin, Rust/Cargo for Rust, Node.js for TypeScript, and Python for Python.

## Tree-sitter

`lua/plugins/treesitter.lua` installs parsers only when the `tree-sitter` executable is available. The configured parsers are:

- `lua`
- `rust`
- `python`
- `javascript`
- `typescript`
- `vim`
- `vimdoc`
- `markdown`
- `markdown_inline`
- `kotlin`

If highlighting or textobjects are missing, check:

```vim
:checkhealth nvim-treesitter
:TSInstallInfo
```

## Local Speech Dependency

`lua/config/speaks.lua` loads `nvim-speaks` directly from a local checkout, not from Lazy:

- Linux/macOS path: `~/code/nvim-speaks/nvim`
- Windows path currently configured: `//wsl.localhost/Ubuntu/home/derek/code/nvim-speaks/nvim`

Set up that repo before starting this config, or comment out `require("config.speaks")` in `init.lua` until it exists.

The speech command is:

```lua
{ "tcp-relay", "127.0.0.1", "7533" }
```

So `tcp-relay` also needs to be installed and available on `PATH` for speech output to work.

## Windows Status

Windows is not fully working yet. There is partial Windows-specific shell handling in `lua/config/locals.lua`, which switches Neovim to `pwsh`, and `lua/config/speaks.lua` points at the WSL copy of `nvim-speaks`.

Known follow-up work:

- Confirm the `nvim-speaks` path and `tcp-relay` behavior from native Windows Neovim.
- Confirm Lazy native builds, especially `blink.cmp`.
- Confirm Mason language server installs under `pwsh`.
- Decide whether Windows should run native tools or use WSL paths consistently.
