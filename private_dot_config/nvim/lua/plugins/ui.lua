vim.g.snacks_animate = false
vim.opt.guicursor:append("a:blinkon0")

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "moon",
      on_colors = function(colors)
        colors.border = "#6ea3fe"
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/snacks.nvim",
    event = "VeryLazy",

    opts = {
      explorer = {
        -- your explorer configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      picker = {
        ignored = true,
        hidden = true,
        exclude = {
          ".git",
          -- "node_modules",
        },
        sources = {
          files = {
            ignored = true,
            hidden = true,
          },
          explorer = {
            -- your explorer picker configuration comes here
            -- or leave it empty to use the default settings
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
    },
  },
}
