vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Treesitter
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use {
      "eckon/treesitter-current-functions",
      requires = { "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },
    }

    use { 'slyces/hierarchy.nvim', requires = 'nvim-treesitter/nvim-treesitter' }

    --colorscheme
    use "savq/melange"

    use "folke/tokyonight.nvim"
    use "theprimeagen/harpoon"

    use "mbbill/undotree"

    use { 'nvim-telescope/telescope-ui-select.nvim' }

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },

        }
    }

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use { 'drewtempelmeyer/palenight.vim' }
    use { 'olimorris/onedarkpro.nvim' }

    use { 'mfussenegger/nvim-jdtls' }

    use { "Slotos/telescope-lsp-handlers.nvim" }

    use 'nvim-telescope/telescope-fzy-native.nvim'

	use {
	  "nvim-tree/nvim-web-devicons",
	  opts = {
		color_icons = true, -- Enable different highlight colors per icon
		default = true, -- Enable default icons globally
		strict = true, -- Ensure strict selection of icons
		variant = "dark", -- Set manually (can be "light" or "dark")
	  }
	}

    use {
        "mfussenegger/nvim-dap",
        opt = true,
        event = "BufReadPre",
        module = { "dap" },
        requires = {
            'ravenxrz/DAPInstall.nvim',
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
--            { "leoluz/nvim-dap-go", module = "dap-go" },
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        }
    }

    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup() 
        end,

    }

    -- Unless you are still migrating, remove the deprecated commands from v1.x
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    use 'mfussenegger/nvim-lint'
    use 'tpope/vim-fugitive'

    use {
      "numToStr/Comment.nvim",
      config = function() require("Comment").setup() end,
    }

    use {
      "nvim-lualine/lualine.nvim",
      config = function() require "iasai1.statusline" end,
      requires = { "nvim-tree/nvim-web-devicons", opt = true },
    }
    
    use {
        dir = IS_DEV and "~/Projects/research/CopilotChat.nvim" or nil,
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = "canary",
        requires = {
          { 'nvim-telescope/telescope.nvim' },
          { 'nvim-lua/plenary.nvim' },
          { 'github/copilot.vim' }
		},
    }

	use {
	  "lima1909/resty.nvim",
	  requires = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim"
	  },
	  config = function()
		require("resty").setup({
		  result_split = true, -- Show results in a split window
		  result_format = "json", -- Format response output
--		  favorite_dir = vim.fn.stdpath("config") .. "/resty_requests", -- Scratch file storage
		})

	  end
  }	
		-- nvim-tree with devicons
	  use {
		'nvim-tree/nvim-tree.lua',
		requires = {
		  'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		config = function()
		  require('nvim-tree').setup {
			renderer = {
			  group_empty = true, -- Compact empty folders
			  icons = {
				show = {
				  file = true,
				  folder = true,
				  folder_arrow = true,
				  git = true,
				},
			  },
			},
			actions = {
			  open_file = {
				quit_on_open = false,
				resize_window = true,
			  },
			},
			view = {
			  width = 40,
			  side = 'left',
			  preserve_window_proportions = false,
			},
			hijack_netrw = true,
			update_focused_file = {
			  enable = true,
			  update_cwd = true,
			},
			filters = {
			  dotfiles = false,
--			  custom = { '.git', 'node_modules', '.cache' },
			},
		  }
		end
	  }
end)
