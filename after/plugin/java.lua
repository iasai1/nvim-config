local jdtls = require('jdtls')

local jdt_path = '/home/iasai1/.jdt/jdt-language-server-1.9.0-202203031534/'
local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = '/home/iasai1/.eclipse/' .. project_name
local sdk_path = '/home/iasai1/.sdkman/candidates/java/'

local config = {}
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- The command that starts the language server
-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
config.cmd = {
    -- 💀
    sdk_path .. '17.0.5-tem/bin/java', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', jdt_path .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', jdt_path .. '/config_linux',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_dir,
}

-- 💀
-- This is the default if not provided, you can remove it. Or adjust as needed.
-- One dedicated LSP server & client will be started per unique root_dir

-- Here you can configure eclipse.jdt.ls specific settings
-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
-- for a list of options
config.settings = {
    java = {
        signatureHelp = { enabled = true };
        contentProvider = { preferred = 'fernflower' };
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*"
            },
            filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
            },
        };
        sources = {
            organizeImports = {
                starThreshold = 9999;
                staticStarThreshold = 9999;
            };
        };
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
            },
            hashCodeEquals = {
                useJava7Objects = true,
            },
            useBlocks = true,
        };
        configuration = {
            runtimes = {
                {
                    name = "JavaSE-17",
                    path = sdk_path .. '17.0.5-tem/'
                },
            }
        };
    }
}

config.on_attach = function(client, bufnr)


    --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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
    vim.keymap.set("n", "gr", function ()
        vim.cmd('lua vim.lsp.buf.references()')
        vim.cmd('copen')
    end)
    vim.keymap.set("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
    vim.keymap.set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
    vim.keymap.set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
    vim.keymap.set("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
    -- Java specific
    vim.keymap.set("n", "<leader>di", "<Cmd>lua require('jdtls').organize_imports()<CR>")
    vim.keymap.set("n", "<leader>dt", "<Cmd>lua require('jdtls').test_class()<CR>")
    vim.keymap.set("n", "<leader>dn", "<Cmd>lua require('jdtls').test_nearest_method()<CR>")
    vim.keymap.set("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
    vim.keymap.set("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>")
    vim.keymap.set("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")

    vim.keymap.set("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>")


--    vim.api.nvim_exec([[
--    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
--    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
--    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
--    augroup lsp_document_highlight
--    autocmdo
--    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--    augroup END
--  ], false)
      print("SLAM")
end

config.capabilities = {
    workspace = {
        configuration = true
    },
    textDocument = {
        completion = {
            completionItem = {
                snippetSupport = true
            }
        }
    }
}

-- Language server `initializationOptions`
-- You need to extend the `bundles` with paths to jar files
-- if you want to use additional eclipse.jdt.ls plugins.
--
-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
--
-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.classFileContentsSupport = true

config.init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities
}

config.filetypes = {
    "java"
}

config.log_level = "debug"
 -- UI
    local finders = require'telescope.finders'
    local sorters = require'telescope.sorters'
    local actions = require'telescope.actions'
    local pickers = require'telescope.pickers'
    require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
      local opts = {}
      pickers.new(opts, {
        prompt_title = prompt,
        finder    = finders.new_table {
          results = items,
          entry_maker = function(entry)
            return {
              value = entry,
              display = label_fn(entry),
              ordinal = label_fn(entry),
            }
          end,
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr)
          actions.goto_file_selection_edit:replace(function()
            local selection = actions.get_selected_entry(prompt_bufnr)
            actions.close(prompt_bufnr)

            cb(selection.value)
          end)

          return true
        end,
      }):find()
    end


-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
