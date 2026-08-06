vim.api.nvim_create_user_command("LuaDump", function(opts)
  local chunk, err = load("return " .. opts.args, "LuaDump", "t", _G)

  if not chunk then
    chunk, err = load(opts.args, "LuaDump", "t", _G)
  end

  if not chunk then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local ok, result = pcall(chunk)
  if not ok then
    vim.notify(result, vim.log.levels.ERROR)
    return
  end

  local text = vim.inspect(result)
  local lines = vim.split(text, "\n", { plain = true })

  vim.cmd("new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.filetype = "lua"

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, {
  nargs = "+",
  complete = "lua",
})

-- Define a share command that dumps the buffer to ~/share
vim.api.nvim_create_user_command("Share", function(opts)
  local filename = vim.fn.expand("%:t")
  local target = vim.fn.expand("~/share/" .. filename)

  local start_line = opts.line1 - 1
  local end_line = opts.line2

  local lines
  if opts.range > 0 then
    lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  else
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  end

  vim.fn.writefile(lines, target)
end, {
  range = true,
})
