vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local actions = require('telescope.actions')
local state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values

-- Function to get the list of changed files
local function get_changed_files(base)
  -- Get the name of the current branch
  local current_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')

  -- Get the list of changed files between the current branch and the specified base
  local result = vim.fn.systemlist('git diff --name-only ' .. base .. '...' .. current_branch)

  -- If there are no changed files, return an empty list
  if #result == 0 then
    print("No changed files")
    return {}
  end

  return result
end

-- Function to open the diff of a selected file
local function open_diff(base, prompt_bufnr)
  local selected_file = state.get_selected_entry(prompt_bufnr).value
  if not selected_file then
    print("No file selected")
    return
  end
  actions.close(prompt_bufnr)
    vim.cmd('edit ' .. selected_file)
  vim.cmd('Gvdiffsplit! ' .. base)
end

-- Function to preview the changes in a file in the Telescope preview window
local function preview_diff(base, entry, bufnr)
  if not entry or not entry.value then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"No preview available"})
    return
  end

  local file = entry.value
  local preview_command = 'git diff ' .. base .. ' -- ' .. file
  local preview_content = vim.fn.systemlist(preview_command)

  -- Clear the buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

  -- Check if preview_content is not empty and is a table
  if preview_content and type(preview_content) == 'table' then
    -- Set the preview content
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, preview_content)
  else
    -- Handle case where preview_content is not as expected
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"Error retrieving diff"})
  end
end

-- Setup Telescope to list changed files
local function list_changed_files_with_telescope(base)
  local changed_files = get_changed_files(base)

  if #changed_files == 0 then
    return
  end

  local preview_enabled = false

  local function toggle_preview(prompt_bufnr)
    local current_picker = state.get_current_picker(prompt_bufnr)
    if preview_enabled then
      current_picker.previewer = nil
    else
      current_picker.previewer = previewers.new_buffer_previewer {
        define_preview = function(entry, bufnr)
          preview_diff(base, entry, bufnr)
        end
      }
    end
    preview_enabled = not preview_enabled
    current_picker:refresh()
  end

  local picker = pickers.new({}, {
    prompt_title = 'Changed Files',
    finder = finders.new_table {
      results = changed_files,
    },
    sorter = conf.generic_sorter({}),
    previewer = nil,  -- Start with no previewer
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function() open_diff(base, prompt_bufnr) end)
      map('n', '<CR>', function() open_diff(base, prompt_bufnr) end)
      map('i', '<C-p>', function() toggle_preview(prompt_bufnr) end)
      map('n', '<C-p>', function() toggle_preview(prompt_bufnr) end)
      return true
    end
  })

  picker:find()
end

-- Create a command to run the Telescope function with an optional argument
vim.api.nvim_create_user_command('ListChangedFiles', function(opts)
  local base = opts.args ~= '' and opts.args or 'origin/main'
  list_changed_files_with_telescope(base)
end, { nargs = '?' })

