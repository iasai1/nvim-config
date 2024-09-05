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
    mapping = cmp_mappings
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
            settings = {
                pylsp = {
                    configurationSources = { "pycodestyle" },  -- This should work, but you can also use "flake8" or "mypy" here
                    plugins = {
                        pycodestyle = { enabled = true },  -- Enable pycodestyle diagnostics
                        black = { enabled = true },        -- Enable black for formatting
                        mypy = { enabled = false },         -- Enable mypy for type-checking
                        rope_autoimport = { enabled = true },  -- Enable rope for autoimport
                        rope_completion = { enabled = true },  -- Enable rope for autocompletion
                        flake8 = { enabled = false, ignore = { "E203" } },  -- Enable flake8 and ignore rule E203
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
})
