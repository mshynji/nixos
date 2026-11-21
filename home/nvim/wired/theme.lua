-- Monochrome by default: structure comes from weight and brightness.
-- Hue appears only for diagnostics and diffs, where it carries information.
local M = {}

function M.apply()
  local c = require("wired_generated").colors
  vim.cmd("highlight clear")
  vim.g.colors_name = "wired"
  vim.o.background = "dark"

  local groups = {
    Normal = { fg = c.fg, bg = c.black },
    NormalFloat = { fg = c.fg, bg = c.black },
    FloatBorder = { fg = c.white, bg = c.black },
    FloatTitle = { fg = c.white, bold = true },
    Cursor = { fg = c.black, bg = c.white },
    CursorLine = { bg = c.bg1 },
    CursorLineNr = { fg = c.white, bold = true },
    LineNr = { fg = c.dim },
    SignColumn = { bg = c.black },
    ColorColumn = { bg = c.bg1 },
    WinSeparator = { fg = c.line },
    StatusLine = { fg = c.gray, bg = c.black },
    StatusLineNC = { fg = c.dim, bg = c.black },
    Visual = { fg = c.black, bg = c.white },
    Search = { fg = c.black, bg = c.gray },
    IncSearch = { fg = c.black, bg = c.white },
    CurSearch = { fg = c.black, bg = c.white },
    MatchParen = { fg = c.white, bold = true, underline = true },
    Pmenu = { fg = c.gray, bg = c.bg1 },
    PmenuSel = { fg = c.black, bg = c.white },
    PmenuThumb = { bg = c.dim },
    Folded = { fg = c.dim, bg = c.bg1 },
    NonText = { fg = c.line },
    Whitespace = { fg = c.line },
    Directory = { fg = c.white, bold = true },
    Title = { fg = c.white, bold = true },
    ErrorMsg = { fg = c.red },
    WarningMsg = { fg = c.amber },
    MoreMsg = { fg = c.gray },
    Question = { fg = c.white },

    Comment = { fg = c.dim, italic = true },
    Constant = { fg = c.gray },
    String = { fg = c.gray },
    Character = { fg = c.gray },
    Number = { fg = c.white },
    Boolean = { fg = c.white },
    Identifier = { fg = c.fg },
    Function = { fg = c.white },
    Statement = { fg = c.white, bold = true },
    Keyword = { fg = c.white, bold = true },
    Conditional = { fg = c.white, bold = true },
    Repeat = { fg = c.white, bold = true },
    Operator = { fg = c.gray },
    PreProc = { fg = c.gray },
    Type = { fg = c.fg, italic = true },
    Special = { fg = c.gray },
    Delimiter = { fg = c.dim },
    Underlined = { underline = true },
    Todo = { fg = c.black, bg = c.amber, bold = true },

    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.gray, italic = true },
    ["@variable.parameter"] = { fg = c.fg, italic = true },
    ["@property"] = { fg = c.fg },
    ["@function.builtin"] = { fg = c.white },
    ["@constructor"] = { fg = c.white },
    ["@tag"] = { fg = c.white },
    ["@tag.attribute"] = { fg = c.gray },
    ["@tag.delimiter"] = { fg = c.dim },
    ["@punctuation"] = { fg = c.dim },
    ["@markup.heading"] = { fg = c.white, bold = true },
    ["@markup.strong"] = { fg = c.white, bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.link"] = { fg = c.gray, underline = true },
    ["@markup.raw"] = { fg = c.gray },

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.amber },
    DiagnosticInfo = { fg = c.gray },
    DiagnosticHint = { fg = c.violet },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.amber },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.gray },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.violet },

    DiffAdd = { fg = c.green },
    DiffDelete = { fg = c.red },
    DiffChange = { fg = c.amber },
    DiffText = { fg = c.black, bg = c.amber },
    Added = { fg = c.green },
    Removed = { fg = c.red },
    Changed = { fg = c.amber },
    GitSignsAdd = { fg = c.green },
    GitSignsDelete = { fg = c.red },
    GitSignsChange = { fg = c.amber },

    BlinkCmpMenu = { fg = c.gray, bg = c.black },
    BlinkCmpMenuBorder = { fg = c.white, bg = c.black },
    BlinkCmpMenuSelection = { fg = c.black, bg = c.white },
    BlinkCmpLabelMatch = { fg = c.white, bold = true },
    BlinkCmpKind = { fg = c.dim },
    BlinkCmpDocBorder = { fg = c.white, bg = c.black },

    FzfLuaBorder = { fg = c.white },
    FzfLuaTitle = { fg = c.white, bold = true },
    WhichKey = { fg = c.white },
    WhichKeyGroup = { fg = c.gray },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.dim },
    OilDir = { fg = c.white, bold = true },

    RenderMarkdownH1Bg = { fg = c.black, bg = c.white, bold = true },
    RenderMarkdownH2Bg = { fg = c.white, bg = c.bg2, bold = true },
    RenderMarkdownH3Bg = { fg = c.white, bg = c.bg1 },
    RenderMarkdownCode = { bg = c.bg1 },

    WiredMode = { fg = c.black, bg = c.white, bold = true },
    WiredFile = { fg = c.white },
    WiredDim = { fg = c.dim, bg = c.black },
    WiredError = { fg = c.red, bg = c.black },
    WiredWarn = { fg = c.amber, bg = c.black },
  }

  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

return M
