-- Standalone server config. Requires Neovim 0.9 or newer.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- No remote language providers are needed for this config.
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.wrap = false
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.hidden = true
opt.autoread = true
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menuone", "noselect" }
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.pyc", "*/.git/*", "*/node_modules/*", "*/.venv/*" })
opt.laststatus = 2
opt.statusline = " %f %h%m%r%=%y %l:%c %p%% "
opt.termguicolors = true
opt.shortmess:append("I") -- Start with an empty buffer instead of the intro screen.

-- Keep swap recovery; do not persist file contents in undo files on servers.
opt.swapfile = true
opt.undofile = false

-- Contents of lua/config/csm.lua from the main dotfiles.
vim.o.langmap = '^[,ç],¨{,Ç},è`,È",à\\,À|,\'<,">'

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Bootstrap only the plugin manager. lazy.nvim installs the plugins below.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim. Check Git and network access:\n" .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Keep the lockfile beside this init.lua, including when launched with -u.
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      version = "v4.11.0",
      priority = 1000,
      opts = {
        style = "night",
        on_colors = function(colors)
          colors.green1 = "#40d69b"
          colors.yellow = "#efef7f"
          colors.magenta = "#eb75ce"
          colors.cyan = "#00afff"
          colors.bg = "#1e1c2b"
          colors.bg_dark1 = "#1b1e2d"
        end,
      },
      config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd("colorscheme tokyonight")
      end,
    },
    {
      "nvim-mini/mini.nvim",
      version = "v0.16.0",
      config = function()
        require("mini.files").setup({
          windows = { width_preview = 60, width_focus = 60 },
          options = { use_as_default_explorer = true },
          mappings = { go_in_plus = "<cr>" },
          -- Plain prefixes work over SSH without a Nerd Font.
          content = { prefix = function() return "" end },
        })
        -- Match LazyVim's search range using parser-free text objects.
        require("mini.ai").setup({ n_lines = 500 })
        require("mini.surround").setup({
          mappings = {
            add = "gsa",
            delete = "gsd",
            find = "gsf",
            find_left = "gsF",
            highlight = "gsh",
            replace = "gsr",
            update_n_lines = "gsn",
          },
        })
        require("mini.comment").setup()
      end,
    },
  },
  defaults = { lazy = false },
  lockfile = config_dir .. "/lazy-lock.json",
  local_spec = false,
  rocks = { enabled = false },
  checker = { enabled = false },
  change_detection = { notify = false },
})

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
map("n", "<leader>e", function()
  require("mini.files").open(vim.fn.getcwd(), true)
end, { desc = "Explorer (mini.files)" })
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Plugin manager" })
map("n", "<leader><space>", ":find ", { desc = "Find file using command-line completion" })
map("n", "<leader>/", ":vimgrep /", { desc = "Search files with vimgrep" })
map("n", "<leader>ww", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split horizontally" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })

map("n", "<Tab>", ">>", { desc = "Indent line" })
map("n", "<S-Tab>", "<<", { desc = "Unindent line" })
map("x", "<Tab>", ">gv", { desc = "Indent selection" })
map("x", "<S-Tab>", "<gv", { desc = "Unindent selection" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up" })
map("n", "<C-j>", ":move +1<cr>==", { desc = "Move line down", silent = true })
map("n", "<C-k>", ":move -2<cr>==", { desc = "Move line up", silent = true })
map("x", "<C-j>", ":move '>+1<cr>gv=gv", { desc = "Move selection down", silent = true })
map("x", "<C-k>", ":move '<-2<cr>gv=gv", { desc = "Move selection up", silent = true })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bls", "<cmd>buffers<cr>", { desc = "List buffers" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>t", "<cmd>botright split | terminal<cr>i", { desc = "Open terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
map("n", "<leader>xl", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next search result" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous search result" })

local group = vim.api.nvim_create_augroup("server_dots", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
  group = group,
  callback = function()
    -- Run after the triggering event so Neovim can reload changed buffers.
    vim.schedule(function()
      if vim.bo.buftype == "" then
        vim.cmd("checktime")
      end
    end)
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})
