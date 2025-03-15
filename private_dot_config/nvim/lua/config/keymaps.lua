-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-`>", ":split | terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-`>", "<C-\\><C-n><C-w>c", { noremap = true, silent = true })
vim.keymap.set("t", "<C-~>", "<C-\\><C-n>:bd", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gg", require("neogit").open, { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>gd", ":DiffViewOpen", { desc = "Open DiffView" })

-- markdown shortcuts

-- Function to fetch the title from a URL
local function fetch_title(url)
  -- Use curl to fetch the webpage and grep to extract the title
  local handle = io.popen(string.format('curl -s "%s" | grep -oP "(?<=<title>).*?(?=</title>)"', url))
  if not handle then
    print("Failed to fetch title.")
    return url
  end

  local title = handle:read("*a")
  handle:close()
  return title:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
end

-- Function to insert the Markdown-formatted link
local function insert_markdown_link()
  -- Get the URL from the clipboard
  local clipboard_cmd = vim.fn.has("macunix") == 1 and "pbpaste" or "xclip -o -selection clipboard"
  local handle = io.popen(clipboard_cmd)
  if not handle then
    print("Failed to read from clipboard.")
    return
  end

  local url = handle:read("*a")
  handle:close()

  -- Fetch the title
  local title = fetch_title(url)

  -- Insert the Markdown-formatted link
  if title and url then
    local markdown_link = string.format("[%s](%s)", title, url)
    vim.api.nvim_put({ markdown_link }, "c", true, true)
  else
    print("Failed to fetch title or URL.")
  end
end

-- Keybinding for <leader>ml
vim.keymap.set("n", "<leader>ml", "", {
  noremap = true,
  callback = insert_markdown_link,
})

-- from https://github.com/linkarzu/dotfiles-latest/blob/562bcc0323338b810b602430bcf5ecad86d74a16/neovim/neobean/lua/config/keymaps.lua#L2255

-- In visual mode, check if the selected text is already bold and show a message if it is
-- If not, surround it with double asterisks for bold
vim.keymap.set("v", "<leader>mb", function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match("^%*%*.*%*%*$") then
    vim.notify("Text already bold", vim.log.levels.INFO)
  else
    vim.cmd("normal 2gsa*")
  end
end, { desc = "Bold current selection" })

-- -- Multiline unbold attempt
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- If you're in a multiline bold, it will unbold it only if you're on the
-- -- first line
vim.keymap.set("n", "<leader>mb", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%*") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find("%*%*")
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find("%*%*")
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bold_end = right_text:find("%*%*")
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, "\n")
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, "\n")
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
    if inside_surround then
      vim.cmd("normal gsd*.")
    else
      vim.cmd("normal viw")
      vim.cmd("normal 2gsa*")
    end
    vim.notify("Bolded current word", vim.log.levels.INFO)
  end
end, { desc = "Toggle bold markers" })

-- Single word/line bold
-- In normal mode, bold the current word under the cursor
-- If already bold, it will unbold the word under the cursor
-- This does NOT unbold multilines
vim.keymap.set("n", "<leader>mb", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- local row = cursor_pos[1] -- Removed the unused variable
  local col = cursor_pos[2]
  local line = vim.api.nvim_get_current_line()
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%*") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Check if the cursor is inside surrounded text
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
  if inside_surround then
    vim.cmd("normal gsd*.")
  else
    vim.cmd("normal 2gsaiw*")
  end
end, { desc = "Toggle bold on current word or selection" })
