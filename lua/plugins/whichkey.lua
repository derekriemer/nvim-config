return   {
    "folke/which-key.nvim",
    opts = {
      -- which-key defaults to Nerd Font symbols for special keys such as
      -- <Tab> and <CR>. Keep the literal key notation instead.
      replace = {
        key = {
          function(key)
            return key
          end,
        },
      },
      icons = {
        breadcrumb = ">",
        separator = "->",
        ellipsis = "...",
        mappings = false,
        rules = false,
        colors = false,
        keys = {
          Up = "Up ",
          Down = "Down ",
          Left = "Left ",
          Right = "Right ",
          C = "C-",
          M = "M-",
          D = "D-",
          S = "S-",
          CR = "CR",
          Esc = "Esc",
          ScrollWheelDown = "WheelDown",
          ScrollWheelUp = "WheelUp",
          NL = "NL",
          BS = "BS",
          Space = "Space",
          Tab = "Tab",
          F1 = "F1", F2 = "F2", F3 = "F3", F4 = "F4",
          F5 = "F5", F6 = "F6", F7 = "F7", F8 = "F8",
          F9 = "F9", F10 = "F10", F11 = "F11", F12 = "F12",
        },
      },
    },
  }
