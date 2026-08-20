return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.lib",
    },
    build = function(plugin)
      local blink_lib = require("lazy.core.config").plugins["blink.lib"]
      local result = vim
        .system({
          vim.v.progpath,
          "--headless",
          "--clean",
          "--cmd",
          "set runtimepath+=" .. vim.fn.fnameescape(blink_lib.dir),
          "--cmd",
          "set runtimepath+=" .. vim.fn.fnameescape(plugin.dir),
          "+lua local ok, err = require('blink.cmp').build():pwait(); if not ok then error(err) end",
          "+qa",
        }, { text = true })
        :wait()

      if result.code ~= 0 then
        error(result.stderr)
      end
    end,

    opts = {
      appearance = {
        -- Do not render completion-kind Nerd Font glyphs.
        kind_icons = {
          Text = "", Method = "", Function = "", Constructor = "", Field = "",
          Variable = "", Property = "", Class = "", Interface = "", Struct = "",
          Module = "", Unit = "", Value = "", Enum = "", EnumMember = "",
          Keyword = "", Constant = "", Snippet = "", Color = "", File = "",
          Reference = "", Folder = "", Event = "", Operator = "", TypeParameter = "",
        },
      },

      completion = {
        documentation = {
          auto_show = false,
        },

        ghost_text = {
          enabled = false,
        },

        menu = {
          auto_show = true,
          auto_show_delay_ms = 2000,
        },
      },

      signature = {
        enabled = false,
      },
    },
  },
}
