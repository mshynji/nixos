local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 120 })
  end,
})

map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>w", "<cmd>write<cr>", { desc = "write" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "quit" })

local fzf = require("fzf-lua")
fzf.setup({
  "max-perf",
  winopts = { border = "single", backdrop = 100, preview = { border = "single" } },
  fzf_colors = {
    ["fg"] = { "fg", "Comment" },
    ["bg"] = { "bg", "Normal" },
    ["hl"] = { "fg", "Function" },
    ["fg+"] = { "fg", "Function" },
    ["bg+"] = { "bg", "CursorLine" },
    ["hl+"] = { "fg", "Function" },
    ["prompt"] = { "fg", "Function" },
    ["pointer"] = { "fg", "Function" },
    ["info"] = { "fg", "Comment" },
    ["border"] = { "fg", "FloatBorder" },
  },
})
map("n", "<leader>f", fzf.files, { desc = "find file" })
map("n", "<leader>/", fzf.live_grep, { desc = "grep" })
map("n", "<leader>b", fzf.buffers, { desc = "buffers" })
map("n", "<leader>h", fzf.helptags, { desc = "help" })
map("n", "<leader>r", fzf.oldfiles, { desc = "recent" })
map("n", "<leader>D", fzf.diagnostics_workspace, { desc = "all diagnostics" })

require("oil").setup({
  default_file_explorer = true,
  columns = {},
  view_options = { show_hidden = true },
})
map("n", "-", "<cmd>Oil<cr>", { desc = "parent directory" })

require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(buf)
    local gs = require("gitsigns")
    map("n", "]h", function() gs.nav_hunk("next") end, { buffer = buf, desc = "next hunk" })
    map("n", "[h", function() gs.nav_hunk("prev") end, { buffer = buf, desc = "previous hunk" })
    map("n", "<leader>gp", gs.preview_hunk, { buffer = buf, desc = "preview hunk" })
    map("n", "<leader>gr", gs.reset_hunk, { buffer = buf, desc = "reset hunk" })
    map("n", "<leader>gb", gs.blame_line, { buffer = buf, desc = "blame line" })
  end,
})

require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.comment").setup()

require("which-key").setup({
  preset = "helix",
  icons = { mappings = false },
  spec = {
    { "<leader>c", group = "code" },
    { "<leader>d", group = "debug" },
    { "<leader>g", group = "git" },
    { "<leader>n", group = "notes" },
  },
})
