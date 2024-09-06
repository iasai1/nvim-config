local lsp = require("lsp-zero")


-- Fix Undefined global 'vim'
-- lsp.configure('lua_ls', {
--     settings = {
--         Lua = {
--             diagnostics = {
--                 globals = { 'vim' }
--             }
--         }
--     }
-- })

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = cmp.mapping.preset.insert({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

local lsp_attach = function(client, bufnr)
    -- Mappings.
    vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
    vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
    vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
    vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
    vim.keymap.set("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

    vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>")
    vim.keymap.set("n", "<leader>/", "<cmd>lua vim.lsp.buf.code_action()<CR>")
end

lsp.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp' }, -- Enable LSP-based autocompletion
        { name = 'buffer' },   -- Enable buffer-based completion
        { name = 'path' },     -- Enable filesystem path completion
    },
    snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
    },
})

require("mason").setup()
lsp.ui({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

require('mason-lspconfig').setup({
  handlers = {
    lsp.setup(),
    pylsp = function()
        require('lspconfig').pylsp.setup({
            flags = {
                debounce_text_changes = 150,  -- Lower debounce time to refresh diagnostics faster
            },
            settings = {
                pylps = {
                    plugins = {
                        flake8 = { enabled = false },         -- Disable Flake8 linting
                        pycodestyle = { enabled = false },    -- Disable Pycodestyle linting
                        pylint = { enabled = false },         -- Disable Pylint linting
                        black = { enabled = false },          -- Disable Black formatting
                        autopep8 = { enabled = false },       -- Disable autopep8 formatting
                        mypy = { enabled = false },           -- Disable Mypy type checking 
                    }
                }
            }
        })
    end,
  }
})

lsp.setup()
require('lspconfig').bashls.setup({})
require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },  -- Tell the LSP that 'vim' is a global variable
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),  -- Make the server aware of Neovim runtime files
        checkThirdParty = false,  -- Avoid prompts to check for third-party libraries
      },
      telemetry = {
        enable = false,  -- Disable telemetry to prevent reporting usage data
      },
    },
  },
}

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
