local colors = require("tokyonight.colors").setup() -- pass in any of the config options as explained above

return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/Nextcloud/obsidian-default/1lists/**",
      org_default_notes_file = "~/Nextcloud/org/refile.org",
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
