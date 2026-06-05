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

    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = {
          set_jumps = true,
        },
      })

      local move = require("nvim-treesitter-textobjects.move")

      local function next_start(capture, group)
        return function()
          move.goto_next_start(capture, group)
        end
      end

      local function previous_start(capture, group)
        return function()
          move.goto_previous_start(capture, group)
        end
      end

      local maps = {
        { "]h", next_start("@heading.outer", "textobjects"), "Next heading" },
        { "[h", previous_start("@heading.outer", "textobjects"), "Previous heading" },
        { "]s", next_start("@section.outer", "textobjects"), "Next section" },
        { "[s", previous_start("@section.outer", "textobjects"), "Previous section" },
        { "]l", next_start("@list.outer", "textobjects"), "Next list" },
        { "[l", previous_start("@list.outer", "textobjects"), "Previous list" },
        { "]L", next_start("@list_item.outer", "textobjects"), "Next list item" },
        { "[L", previous_start("@list_item.outer", "textobjects"), "Previous list item" },
        { "]b", next_start("@block.outer", "textobjects"), "Next block" },
        { "[b", previous_start("@block.outer", "textobjects"), "Previous block" },
        { "]f", next_start("@fold", "folds"), "Next fold" },
        { "[f", previous_start("@fold", "folds"), "Previous fold" },
      }

      for _, map in ipairs(maps) do
        vim.keymap.set({ "n", "x", "o" }, map[1], map[2], { desc = map[3] })
      end
    end,
  },
}
