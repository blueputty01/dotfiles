local colors = require("tokyonight.colors").setup() -- pass in any of the config options as explained above

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "@org.agenda.scheduled", { fg = "#AAFFAA" })
  end,
})

return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/Nextcloud/obsidian-default/1lists/**",
      org_agenda_custom_commands = {
        T = {
          name = "TODO",
          description = "match only TODO",
          types = {
            {
              type = "tags_todo",
              match = 'TODO="TODO"',
            },
          },
        },
        s = {
          name = "Shallow",
          description = "Shallow",
          types = {
            {
              type = "tags",
              match = "shallow", --Same as providing a "Match:" for tags view <leader>oa + m, See: https://orgmode.org/manual/Matching-tags-and-properties.html
              org_agenda_todo_ignore_scheduled = "all", -- Ignore all headlines that are scheduled. Possible values: past | future | all
            },
          },
        },
      },
      org_todo_keywords = {
        "TODO(t)",
        "WAITING",
        "SOMEDAY",
        "SNOOZED(z)",
        "NEXT",
        "DEADLINE",
        "|",
        "DONE",
      },
      calendar_week_start_day = 0,
      org_todo_keyword_faces = {
        TODO = ":foreground orange", -- overrides builtin color for `TODO` keyword
        WAITING = ":slant italic",
        SOMEDAY = ":foreground gray",
        SNOOZED = ":foreground gray",
        NEXT = ":foreground gray",
        DEADLINE = ":slant italic :underline on",
        DONE = ":underline on",
      },
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}
