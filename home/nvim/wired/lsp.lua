local map = vim.keymap.set

local blink = require("blink.cmp")
blink.setup({
  keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 250 },
    menu = {
      border = "single",
      draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } },
    },
  },
  sources = { default = { "lsp", "path", "buffer" } },
})

vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    },
  },
})

vim.lsp.config("nixd", {
  settings = { nixd = { formatting = { command = { "nixfmt" } } } },
})

vim.lsp.enable({
  "nixd",
  "lua_ls",
  "basedpyright",
  "ruff",
  "ts_ls",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "clangd",
  "rust_analyzer",
  "gopls",
  "dockerls",
  "docker_compose_language_service",
  "yamlls",
  "terraformls",
  "bashls",
  "marksman",
  "tinymist",
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { prefix = "", spacing = 2 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local fzf = require("fzf-lua")
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc }
    end
    map("n", "gd", fzf.lsp_definitions, opts("definition"))
    map("n", "gr", fzf.lsp_references, opts("references"))
    map("n", "gi", fzf.lsp_implementations, opts("implementation"))
    map("n", "K", vim.lsp.buf.hover, opts("hover"))
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts("code action"))
    map("n", "<leader>cr", vim.lsp.buf.rename, opts("rename"))
    map("n", "<leader>cs", fzf.lsp_document_symbols, opts("symbols"))
  end,
})

-- Formatting is on demand so it never rewrites a shared repo by surprise.
local web = { "prettierd" }
require("conform").setup({
  formatters_by_ft = {
    nix = { "nixfmt" },
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = web,
    javascriptreact = web,
    typescript = web,
    typescriptreact = web,
    html = web,
    css = web,
    json = web,
    yaml = web,
    markdown = web,
    sh = { "shfmt" },
    go = { "gofumpt" },
    rust = { "rustfmt" },
    terraform = { "terraform_fmt" },
  },
  default_format_opts = { lsp_format = "fallback" },
})
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true })
end, { desc = "format" })
