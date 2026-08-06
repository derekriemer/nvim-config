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
