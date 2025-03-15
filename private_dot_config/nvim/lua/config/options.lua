-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 0
  end,
})

-- cd to opened directory
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    -- Get args directly from vim.v.argv
    local args = vim.v.argv
    -- Check if the dir argument is provided
    print(#args)
    if #args >= 3 then
      local dir = args[3]

      -- Check if the argument is a directory
      if vim.fn.isdirectory(dir) == 1 then
        vim.cmd.cd(dir)
      end
    end
  end,
})

vim.g.ai_cmp = false
