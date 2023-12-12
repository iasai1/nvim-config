local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'lua_ls',
  'bashls'
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})


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
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.rename()<CR>")
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

    vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>")
    vim.keymap.set("n", "<leader>/", "<cmd>lua vim.lsp.buf.code_action()<CR>")

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


lsp.setup()
require('lspconfig').bashls.setup({})

vim.diagnostic.config({
    virtual_text = true,
})
