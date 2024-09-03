-- Open Netrw on the directory of the current file
vim.api.nvim_set_keymap('n', '<leader>pv', ':Lexplore %:p:h<CR>', { noremap = true, silent = true })

-- Toggle the Netrw window
vim.api.nvim_set_keymap('n', '<leader>pa', ':Lexplore<CR>', { noremap = true, silent = true })

-- Set Netrw window size based on screen width
if vim.o.columns < 90 then
  vim.g.netrw_winsize = 50
else
  vim.g.netrw_winsize = 30
end

-- Sync current directory and browsing directory
vim.g.netrw_keepdir = 0

-- Hide Netrw banner
vim.g.netrw_banner = 0

-- Hide dotfiles
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]

-- Use a better copy command
vim.g.netrw_localcopydircmd = 'cp -r'

-- Function to delete a non-empty directory
function _G.NetrwRemoveRecursive()
  if vim.bo.filetype == 'netrw' then
    local bufnr = vim.api.nvim_get_current_buf()

    -- Prepare the delete command.
    -- Make it so that it's triggered by just pressing Enter
    vim.api.nvim_buf_set_keymap(bufnr, 'c', '<CR>', 'rm -r<CR>', { noremap = true, silent = true })

    -- Unmark all files (don't want to delete anything by accident)
    vim.cmd('normal! mu')

    -- Mark the file/directory under the cursor
    vim.cmd('normal! mf')

    -- Show the prompt to enter the command
    local status, err = pcall(function() vim.cmd('normal! mx') end)
    if not status then
      print("Canceled")
    end

    -- Undo the Enter keymap
    vim.api.nvim_buf_del_keymap(bufnr, 'c', '<CR>')
  end
end
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  desc = 'Better mappings for netrw',
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, { remap = true, buffer = true })
    end

    -- Close Netrw window
    bind('<leader>dd', ':Lexplore<CR>')

    -- Go to file and close Netrw window
    bind('L', '<CR>:Lexplore<CR>')

    -- Go back in history
    bind('H', 'u')

    -- Go up a directory
    bind('h', '-^')

    -- Go down a directory / open file
    bind('l', '<CR>')

    -- Toggle dotfiles
    bind('.', 'gh')

    -- Toggle the mark on a file
    bind('<TAB>', 'mf')

    -- Unmark all files in the buffer
    bind('<S-TAB>', 'mF')

    -- Unmark all files
    bind('<leader><TAB>', 'mu')

    -- 'Bookmark' a directory
    bind('bb', 'mb')

    -- Delete the most recent directory bookmark
    bind('bd', 'mB')

    -- Go to a directory on the most recent bookmark
    bind('bl', 'gb')

    -- Create a file
    bind('ff', '%:w<CR>:buffer #<CR>')

    -- Rename a file
    bind('fe', 'R')

    -- Copy marked files
    bind('fc', 'mc')

    -- Copy marked files in the directory under cursor
    bind('fC', 'mtmc')

    -- Move marked files
    bind('fx', 'mm')

    -- Move marked files in the directory under cursor
    bind('fX', 'mtmm')

    -- Execute a command on marked files
    bind('f;', 'mx')

    -- Show the list of marked files
    bind('fl', ':lua print(table.concat(vim.fn["netrw#Expose"]("netrwmarkfilelist"), "\\n"))<CR>')

    -- Show the current target directory
    bind('fq', ':lua print("Target: " .. vim.fn["netrw#Expose"]("netrwmftgt"))<CR>')

    -- Set the directory under the cursor as the current target
    bind('fd', 'mtfq')

    -- Delete a file
    bind('FF', ':lua NetrwRemoveRecursive()<CR>')

    -- Close the preview window
    bind('P', '<C-w>z')
  end
})
