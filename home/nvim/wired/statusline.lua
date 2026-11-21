local modes = {
  n = "norm",
  i = "ins",
  v = "vis",
  V = "line",
  ["\22"] = "blck",
  c = "cmd",
  R = "repl",
  t = "term",
  s = "sel",
}

function _G.WiredStatusline()
  local mode = modes[vim.fn.mode():sub(1, 1)] or "----"
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local branch = vim.b.gitsigns_head and (" " .. vim.b.gitsigns_head) or ""

  local parts = {
    "%#WiredMode# " .. mode .. " ",
    "%#WiredFile# %f%m%r",
    "%#WiredDim#" .. branch,
    "%=",
  }
  if errors > 0 then
    parts[#parts + 1] = "%#WiredError#e" .. errors .. " "
  end
  if warnings > 0 then
    parts[#parts + 1] = "%#WiredWarn#w" .. warnings .. " "
  end
  parts[#parts + 1] = "%#WiredDim#%{&filetype}  %l:%c  %p%% "
  return table.concat(parts)
end

vim.o.statusline = "%!v:lua.WiredStatusline()"
