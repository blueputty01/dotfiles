return {
  "b0o/incline.nvim",
  config = function()
    -- local helpers = require("incline.helpers")
    -- local devicons = require("nvim-web-devicons")
    require("incline").setup({
      window = {
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
      },
      hide = {
        cursorline = true,
      },
      render = function(p)
        local full_path = vim.api.nvim_buf_get_name(p.buf)
        local function escape_pattern(str)
          return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%q?])", "%%%1")
        end
        local cwd = escape_pattern(vim.fn.getcwd())
        return full_path:gsub(cwd, ".")
      end,
      --     render = function(props)
      --       local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      --       if filename == "" then
      --         filename = "[No Name]"
      --       end
      --       local ft_icon, ft_color = devicons.get_icon_color(filename)
      --       local modified = vim.bo[props.buf].modified
      --       local res = {
      --         ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
      --         " ",
      --         { filename, gui = modified and "bold,italic" or "bold" },
      --         guibg = "#44406e",
      --       }
      --       table.insert(res, " ")
      --       return res
      --     end,
    })
  end,
  -- Optional: Lazy load Incline
  event = "VeryLazy",
}
