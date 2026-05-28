return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = true,

          keymaps = {
            init_selection = "<leader>ss",
            node_incremental = "<leader>si",
            node_decremental = "<leader>sd",
            scope_incremental = "<leader>sc",
          },
        },

        ensure_installed = {
          "lua",
          "rust",
          "python",
          "javascript",
          "typescript",
          "vim",
          "vimdoc",
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
