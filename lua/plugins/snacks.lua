local function relative_path(path, cwd)
  if not path or path == "" then
    return nil
  end

  local normalized_path = vim.fs.normalize(path)
  local normalized_cwd = cwd and vim.fs.normalize(cwd) or nil

  if normalized_cwd and normalized_path:sub(1, #normalized_cwd + 1) == normalized_cwd .. "/" then
    return normalized_path:sub(#normalized_cwd + 2)
  end

  return normalized_path
end

local function picker_item_text(picker, item)
  if not item then
    return nil
  end

  if item.file then
    local path = relative_path(item.file, picker and picker.cwd and picker:cwd() or item.cwd)
    if path and picker and picker.opts and picker.opts.source == "explorer" then
      local basename = vim.fn.fnamemodify(path, ":t")
      return basename ~= "" and basename or path
    end
    if path then
      return path
    end
  end

  return item.text
    or item.label
    or item.name
    or item.path
    or item.value
end

local function announce_picker_item(picker, item)
  local ok, speaks = pcall(require, "nvim-speaks")
  if not ok then
    return
  end

  local text = picker_item_text(picker, item)
  if type(text) ~= "string" or text == "" then
    return
  end

  speaks.announce(text, {
    category = "picker",
    interrupt = true,
    source = "snacks.nvim",
  })
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      explorer = {
        enabled = true,
        replace_netrw = true,
        trash = true,
      },

      input = {
        enabled = true,
      },

      picker = {
        enabled = true,
        prompt = "> ",
        ui_select = true,
        on_change = announce_picker_item,

        icons = {
          files = {
            enabled = false,
          },
          git = {
            enabled = false,
          },
          diagnostics = {
            Error = "error ",
            Warn = "warning ",
            Hint = "hint ",
            Info = "info ",
          },
        },

        formatters = {
          file = {
            icon_width = 0,
          },
          severity = {
            icons = false,
            level = true,
          },
        },

        layout = {
          preset = "vertical",
          hidden = { "preview" },
        },

        win = {
          input = {
            keys = {
              ["<Tab>"] = { "list_down", mode = { "i", "n" } },
              ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<Tab>"] = "list_down",
              ["<S-Tab>"] = "list_up",
            },
          },
        },
      },
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    },
  },
}
