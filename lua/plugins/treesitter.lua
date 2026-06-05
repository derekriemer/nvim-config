return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local treesitter = require("nvim-treesitter")
      local parsers = {
        "lua",
        "rust",
        "python",
        "javascript",
        "typescript",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
      }

      treesitter.setup()

      if vim.fn.executable("tree-sitter") == 1 then
        treesitter.install(parsers)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("derek_treesitter", { clear = true }),
        pattern = {
          "lua",
          "rust",
          "python",
          "javascript",
          "typescript",
          "vim",
          "vimdoc",
          "markdown",
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      vim.keymap.set("n", "<leader>ss", "van", { desc = "Start tree-sitter selection", remap = true })
      vim.keymap.set("x", "<leader>si", "an", { desc = "Increment tree-sitter selection", remap = true })
      vim.keymap.set("x", "<leader>sd", "in", { desc = "Decrement tree-sitter selection", remap = true })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
