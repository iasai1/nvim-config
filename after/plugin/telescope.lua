local builtin = require('telescope.builtin')
local telescope = require("telescope")

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fd', "<cmd>Telescope live_grep search_dirs={" .. vim.fn.getcwd() .. "}<CR>", {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})


vim.keymap.set('n', '<leader>pf', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

telescope.setup {
    layout_strategy = 'vertical',
      --layout_config = { height = 0.95, width = 0.95 },

    defaults = {
        path_display = {"smart"},
        warp_results = true,
        preview = {
            hide_on_startup = true
        },
        mappings = {
            i = {
                ['<C-p>'] = require('telescope.actions.layout').toggle_preview
            }
        }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_cursor {
                -- even more opts
            }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
}

telescope.load_extension('lsp_handlers')
telescope.load_extension('fzy_native')

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")


require'telescope-lsp-handlers'.setup({
    reference = {
        disabled = false,
        picker = { warp_results = true, prompt_title = 'LSP References' },
        no_results_message = 'No references found'
  },
})
