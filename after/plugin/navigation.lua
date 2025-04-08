-- Disable netrw at the start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  hijack_netrw = true,  -- Prevents netrw from opening
  update_focused_file = {
    enable = true,
    update_cwd = true,
    update_root = true,  -- Updates the root directory to the current file's directory
    ignore_list = {},    -- List of file patterns to ignore
 },
})

vim.keymap.set("n", "<leader>pv", "<cmd>NvimTreeToggle<CR>")
