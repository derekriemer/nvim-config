-- lua/my/fold_imports.lua
local M = {}

function M.fold_block(opts)
  local start_pat = opts.start_pat
  local line_ok = opts.line_ok

  local first = vim.fn.search(start_pat, "nw")
  if first == 0 then return end

  local last = first
  for lnum = first + 1, vim.fn.line("$") do
    local line = vim.fn.getline(lnum)

    if line_ok(line) then
      last = lnum
    else
      break
    end
  end

  vim.cmd(first .. "," .. last .. "fold")
end

return M



-- how to drive this per lang.
--

-- after/ftplugin/kotlin.lua
local folds = require("my.fold_imports")

vim.schedule(function()
  folds.fold_block({
    start_pat = [[^import\>]],
    line_ok = function(line)
      return line:match("^import%s") or line:match("^%s*$")
    end,
  })
end)

-- We'd need to find "from" at start in python too.
