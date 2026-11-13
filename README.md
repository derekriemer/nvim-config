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

Alternatively, keep the repo in `~/code/nvim-config` and symlink it into Neovim's config directory:

```sh
mkdir -p ~/.config
ln -s ~/code/nvim-config ~/.config/nvim
nvim
```

If `~/.config/nvim` already exists, move it to a backup location before creating the symlink. Adjust the source path if you cloned the repo somewhere else.

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

`lua/config/speaks.lua` loads the speech plugin and TCP bridge from local checkouts. On Linux or inside WSL, install `git`, `bash`, and `socat`, then run from this repo:

```sh
# Ubuntu/Debian:
sudo apt install git bash socat
./bootstrap.sh
```

The script clones these repositories over HTTPS:

- [nvim-speaks](https://github.com/derekriemer/nvim-speaks) into `~/code/nvim-speaks/nvim-speaks`.
- [nvim-speaks-tcp-bridge](https://github.com/derekriemer/nvim-speaks-tcp-bridge) into `~/code/nvim-speaks/nvim-speaks-tcp-bridge`.

The script also symlinks this config checkout into `${XDG_CONFIG_HOME:-~/.config}/nvim`. It works from any working directory. If a different config or symlink already exists there, it stops and asks you to move it aside; it never overwrites it.

Rerunning the script keeps existing checkouts and a matching config link unchanged; it does not pull updates.

The config adds the plugin checkout to Neovim's runtimepath and launches the bridge with Bash using its absolute path, so no extra `PATH` setup is needed. The bridge uses `socat` to connect to `127.0.0.1:7533`.

This is the current relay setup for Linux/WSL. The custom Rust `tcp-relay` is not required.

Run your speech server separately on that endpoint (or forward it there using an SSH tunnel). The bootstrap script does not install or start a speech server. For native Windows, [nvim-speaks-windows-server](https://github.com/derekriemer/nvim-speaks-windows-server) provides NVDA/SAPI backends; follow that repo's build and setup instructions on the Windows host.

## Windows Status

Windows is not fully working yet. There is partial Windows-specific shell handling in `lua/config/locals.lua`, which switches Neovim to `pwsh`, and `lua/config/speaks.lua` points at the WSL speech checkouts under `//wsl.localhost/Ubuntu/home/derek/code/nvim-speaks`.

Known follow-up work:

- Confirm the WSL checkout paths and Bash/`socat` bridge invocation from native Windows Neovim. The bootstrap script targets Linux/WSL, not native Windows.
- Confirm Lazy native builds, especially `blink.cmp`.
- Confirm Mason language server installs under `pwsh`.
- Decide whether Windows should run native tools or use WSL paths consistently.
