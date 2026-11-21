vim.g.mapleader = " "
vim.g.maplocalleader = ","

local o = vim.opt
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
o.showmode = false
o.laststatus = 3
o.scrolloff = 6
o.wrap = false
o.linebreak = true
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.undofile = true
o.updatetime = 250
o.clipboard = "unnamedplus"
o.winborder = "single"
o.fillchars = { eob = " ", vert = "│", horiz = "─" }
o.list = true
o.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

require("wired.theme").apply()
require("wired.statusline")
require("wired.editor")
require("wired.lsp")
require("wired.debug")
require("wired.notes")
