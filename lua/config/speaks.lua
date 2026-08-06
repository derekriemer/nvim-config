local is_windows = vim.fn.has("win32") == 1

if is_windows then
  vim.opt.runtimepath:prepend("//wsl.localhost/Ubuntu/home/derek/code/nvim-speaks/nvim")
else
  vim.opt.runtimepath:prepend(vim.fn.expand("~/code/nvim-speaks/nvim"))
end

require("nvim-speaks").setup({
  command =  {
    "tcp-relay",
    "127.0.0.1",
    "7533",
  },
  speech = {
    indent_mode = "tone",
  },
})
