vim.g.snacks_animate = false
vim.opt.guicursor = ""

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
}
