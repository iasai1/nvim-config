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
    defaults = {
        path_display = "truncate",
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
            require("telescope.themes").get_dropdown {
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

telescope.setup({
	extensions = {
		lsp_handlers = {
			disable = {},
			location = {
				telescope = require('telescope.themes').get_dropdown({}),
				no_results_message = 'No references found',
			},
			symbol = {
				telescope = {},
				no_results_message = 'No symbols found',
			},
			call_hierarchy = {
				telescope = require('telescope.themes').get_dropdown({}),
				no_results_message = 'No calls found',
            },
            references = {
                telescope = require('telescope.themes').get_dropdown({}),
				no_results_message = 'No calls found',
            },
            implementation = {
				telescope = require('telescope.themes').get_dropdown({}),
				no_results_message = 'No calls found',
            },
		},
	}
})



-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
