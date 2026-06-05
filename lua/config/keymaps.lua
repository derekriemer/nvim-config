vim.keymap.set("n", "<leader>fi", function()
  vim.opt_local.foldmethod = "indent"
  vim.opt_local.foldenable = true
  vim.cmd("normal! zM")
end, { desc = "Fold by indent" })

vim.keymap.set("n", "<leader>fl", function()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt_local.foldenable = true
  vim.cmd("normal! zM")
end, { desc = "Fold by tree-sitter" })

vim.keymap.set("n", "<leader>fo", function()
  vim.cmd("normal! zR")
end, { desc = "Open all folds" })

vim.keymap.set("n", "<leader>ft", function()
  vim.opt_local.foldenable = not vim.opt_local.foldenable:get()
end, { desc = "Toggle folds" })

vim.api.nvim_create_user_command("Share", function()
  vim.cmd.write(vim.fn.expand("~/share/" .. vim.fn.expand("%:t")))
end, {})
