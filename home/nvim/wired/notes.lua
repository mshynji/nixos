-- A plain folder of Markdown and Typst. No database, no lock-in.
local map = vim.keymap.set
local root = vim.fn.expand("~/notes")

local c = require("wired_generated").colors
require("render-markdown").setup({
  heading = { icons = { "", "", "", "", "", "" }, position = "inline", width = "block", left_pad = 1, right_pad = 2 },
  code = { sign = false, width = "block", border = "thin" },
  bullet = { icons = { "-", "·", "-", "·" } },
  checkbox = {
    unchecked = { icon = "[ ] " },
    checked = { icon = "[x] ", highlight = "Comment" },
  },
})
vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = c.dim })

local function open(path)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.cmd.edit(vim.fn.fnameescape(path))
end

local function index()
  open(root .. "/index.md")
end

vim.api.nvim_create_user_command("WiredNotes", index, {})

map("n", "<leader>nn", index, { desc = "index" })
map("n", "<leader>nd", function()
  open(root .. "/daily/" .. os.date("%Y-%m-%d") .. ".md")
end, { desc = "today" })
map("n", "<leader>nf", function()
  vim.fn.mkdir(root, "p")
  require("fzf-lua").files({ cwd = root })
end, { desc = "find note" })
map("n", "<leader>ng", function()
  vim.fn.mkdir(root, "p")
  require("fzf-lua").live_grep({ cwd = root })
end, { desc = "grep notes" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "typst", "tex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "pt_br" }
  end,
})

-- Live Typst: recompile on save and show the PDF in zathura, which auto-reloads.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(ev)
    map("n", "<leader>np", function()
      local source = vim.api.nvim_buf_get_name(ev.buf)
      local pdf = source:gsub("%.typ$", ".pdf")
      local job = vim.fn.jobstart({ "typst", "watch", source, pdf })
      vim.api.nvim_create_autocmd("BufDelete", {
        buffer = ev.buf,
        once = true,
        callback = function()
          vim.fn.jobstop(job)
        end,
      })
      vim.defer_fn(function()
        vim.fn.jobstart({ "zathura", pdf }, { detach = true })
      end, 1200)
    end, { buffer = ev.buf, desc = "preview typst" })
  end,
})
