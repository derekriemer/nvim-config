vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.ruler=false
vim.opt.mouse = "a"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.opt.shell = "bash"

vim.opt.shellquote = ""
vim.opt.shellxquote = ""

local osc52_hosts = {
  ["derekriemer.com"] = true,
  ["el-zorro"] = true,
}

local hostname = vim.uv.os_gethostname()
local is_ssh_session = vim.env.SSH_CONNECTION ~= nil
  or vim.env.SSH_CLIENT ~= nil
  or vim.env.SSH_TTY ~= nil

if osc52_hosts[hostname] or is_ssh_session then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }

  vim.opt.clipboard = "unnamedplus"
end
