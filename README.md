# srvr-dots

Small dotfiles for servers: a Neovim config and a tmux config, both
plugin-free apart from lazy.nvim. Needs Neovim 0.9+, tmux 3.2+, and Git 2.19+.
First nvim launch downloads everything automatically.

## Try it

From this repository:

```sh
NVIM_APPNAME=srvr-nvim nvim -u "$PWD/nvim/init.lua"
```

## Install on a server

Clone or copy this repository, then run from its root:

```sh
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_home"
ln -s "$PWD/nvim" "$config_home/srvr-nvim"
ln -s "$PWD/tmux" "$config_home/tmux"
alias snvim='NVIM_APPNAME=srvr-nvim nvim'
```

The symlink picks up changes when you update the checkout. First launch installs
lazy.nvim, `mini.nvim` (files, ai, surround, comment), and `tokyonight.nvim` into
`~/.local/share/srvr-nvim/lazy/`; after that it works offline.

## Plugin management

Open the manager with `:Lazy`. `nvim/lazy-lock.json` pins the versions; after
pulling changes, run:

```sh
NVIM_APPNAME=srvr-nvim nvim --headless "+Lazy! restore" +qa
```

## tmux

Ported from my main config: panes numbered from 1, 50k scrollback, mouse,
activity alerts, fast escape, and a Tokyo Night statusline (session name left,
clock right) matching the nvim theme. No plugins or TPM; reload with Prefix + r.

All shortcuts are defined in `tmux/tmux.conf`.
