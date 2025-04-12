return {
  "zbirenbaum/copilot.lua",
  enabled = vim.fn.hostname() ~= "tulare", -- disable on remote machine
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  opts = {
    suggestion = {
      enabled = not vim.g.ai_cmp,
      auto_trigger = true,
      hide_during_completion = vim.g.ai_cmp,
      keymap = {
        accept = false, -- handled by nvim-cmp / blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
      org = function()
        if string.match(vim.fs.basename(vim.fn.expand("%")), "projects") then
          return false
        end
        return true
      end,
    },
  },
}
