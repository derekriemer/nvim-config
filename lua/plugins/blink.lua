return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.lib",
    },
    build = function()
      require("blink.cmp").build():wait(60000)
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
