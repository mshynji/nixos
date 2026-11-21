local dap = require("dap")
local ui = require("dapui")
local map = vim.keymap.set
local debugpy_python = require("wired_generated").debugpy_python

ui.setup({ icons = { expanded = "-", collapsed = "+", current_frame = ">" } })
dap.listeners.after.event_initialized.wired = ui.open
dap.listeners.before.event_terminated.wired = ui.close
dap.listeners.before.event_exited.wired = ui.close

vim.fn.sign_define("DapBreakpoint", { text = "*", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticWarn", linehl = "CursorLine" })

local program = function()
  return vim.fn.input("program: ", vim.fn.getcwd() .. "/", "file")
end

dap.adapters.lldb = { type = "executable", command = "lldb-dap", name = "lldb" }
local native = {
  { name = "launch", type = "lldb", request = "launch", program = program, cwd = "${workspaceFolder}" },
}
dap.configurations.c = native
dap.configurations.cpp = native
dap.configurations.rust = native

dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = { command = "dlv", args = { "dap", "-l", "127.0.0.1:${port}" } },
}
dap.configurations.go = {
  { name = "package", type = "delve", request = "launch", program = "${fileDirname}" },
  { name = "test", type = "delve", request = "launch", mode = "test", program = "${fileDirname}" },
}

dap.adapters.python = {
  type = "executable",
  command = debugpy_python,
  args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
  {
    name = "file",
    type = "python",
    request = "launch",
    program = "${file}",
    console = "integratedTerminal",
    pythonPath = function()
      local venv = vim.fn.getcwd() .. "/.venv/bin/python"
      return vim.fn.executable(venv) == 1 and venv or "python3"
    end,
  },
}

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable = { command = "js-debug", args = { "${port}", "127.0.0.1" } },
}
local node = {
  { name = "file", type = "pwa-node", request = "launch", program = "${file}", cwd = "${workspaceFolder}" },
}
dap.configurations.javascript = node
dap.configurations.typescript = node

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "continue" })
map("n", "<leader>di", dap.step_into, { desc = "step into" })
map("n", "<leader>do", dap.step_over, { desc = "step over" })
map("n", "<leader>dO", dap.step_out, { desc = "step out" })
map("n", "<leader>dt", dap.terminate, { desc = "terminate" })
map("n", "<leader>du", ui.toggle, { desc = "toggle ui" })
