vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Treesitter
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

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
        "mfussenegger/nvim-dap",
        opt = true,
        event = "BufReadPre",
        module = { "dap" },
        requires = {
            'ravenxrz/DAPInstall.nvim',
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
--            { "leoluz/nvim-dap-go", module = "dap-go" },
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        }
    }

    use {
        "folke/zen-mode.nvim",
        config = function()
            require('zen-mode').setup {
            }
        end
    }

    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup() 
        end,

    }

    use {
        'lewis6991/spellsitter.nvim',
        config = function()
            require('spellsitter').setup()
        end
    }

    -- Unless you are still migrating, remove the deprecated commands from v1.x
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    use {
      "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = { 
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        }
      }

    use 'rstacruz/vim-closer'

    use 'mfussenegger/nvim-lint'
    use 'tpope/vim-fugitive'

    use {
      "numToStr/Comment.nvim",
      config = function() require("Comment").setup() end,
    }

    use {
      "nvim-lualine/lualine.nvim",
      config = function() require "iasai1.statusline" end,
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    }
end)

