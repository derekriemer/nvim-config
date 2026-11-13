local is_windows = vim.fn.has("win32") == 1
local speech_root

if is_windows then
  speech_root = "//wsl.localhost/Ubuntu/home/derek/code/nvim-speaks"
else
  speech_root = vim.fn.expand("~/code/nvim-speaks")
end

vim.opt.runtimepath:prepend(speech_root .. "/nvim-speaks")

require("nvim-speaks").setup({
  command =  {
    "bash",
    speech_root .. "/nvim-speaks-tcp-bridge/speech-to-tcp",
    "127.0.0.1",
    "7533",
  },
  speech = {
    indent_mode = "tone",
  },
})
