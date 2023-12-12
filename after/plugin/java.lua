vim.keymap.set("n", "<leader>aj", "<cmd>lua vim.lsp.buf_attach_client(0, 1)<CR>")

local jdtls = require('jdtls')

local HOME = os.getenv('HOME')
local jdt_path = HOME .. '/.config/jdt'
local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = HOME .. '/.config/eclipse/' .. project_name
local sdk_path = HOME .. '/.sdkman/candidates/java'
local DEBUGGER_LOCATION = HOME .. '/.config/nvim-data/java'

local config = {}
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- The command that starts the language server
-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
config.cmd = {
    -- 💀
    sdk_path .. '/17.0.8-tem/bin/java', -- or '/path/to/java17_or_newer/bin/java'
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

    --lombok
    '-javaagent:' .. HOME .. '/.local/share/eclipse/lombok.jar',
    -- 💀
    '-jar', jdt_path .. '/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar',
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
                    path = sdk_path .. '/17.0.8-tem/'
                },
                {
                    name = "JavaSE-11",
                    path = sdk_path .. '/11.0.20-tem/'
                },
                {
                    name = "JavaSE-1.8",
                    path = sdk_path .. '/8.0.382-tem/'
                },
            }
        };
    }
}

config.on_attach = function(client, bufnr)

    require('jdtls.setup').add_commands()
    jdtls.setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs()
    vim.lsp.codelens.refresh()
    --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

   -- -- Mappings.
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
    vim.keymap.set("n", "<C-/>", "<cmd>lua vim.lsp.buf.code_action()<CR>")
   -- vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
   -- vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
   -- vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
   -- vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
   -- vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
   -- vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
   -- vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
   -- vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
   -- vim.keymap.set("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
   -- vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
   -- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
   -- vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
   -- vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
   -- vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

   -- vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>")
   -- vim.keymap.set("n", "<C-/>", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    -- Java specific
    vim.keymap.set("n", "<leader>ji", "<Cmd>lua require('jdtls').organize_imports()<CR>")
    vim.keymap.set("n", "<leader>jt", "<Cmd>lua require('jdtls').test_class()<CR>")
    vim.keymap.set("n", "<leader>jn", "<Cmd>lua require('jdtls').test_nearest_method()<CR>")
    vim.keymap.set("v", "<leader>je", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
    vim.keymap.set("n", "<leader>je", "<Cmd>lua require('jdtls').extract_variable()<CR>")
    vim.keymap.set("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")

    vim.keymap.set("n", "<leader>jf", "<cmd>lua vim.lsp.buf.formatting()<CR>")


    vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
        autocmdo
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
    ]], false)
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
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.classFileContentsSupport = true
local bundles = {
  vim.fn.glob(
    DEBUGGER_LOCATION .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(DEBUGGER_LOCATION .. "/vscode-java-test/server/*.jar"), "\n"))
config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities
}

local filetypes = { 'java' }
config.filetypes = filetypes
--:config.autostart = true
config.log_level = "debug"

local autocmd
config.on_init = function(client, results)

    local buf_attach = function()
        vim.lsp.buf_attach_client(0, client.id)
    end

    autocmd = vim.api.nvim_create_autocmd('FileType', {
        desc = string.format('Attach LSP: %s', client.name),
        pattern = filetypes,
        callback = buf_attach
    })

    if vim.v.vim_did_enter == 1 and
        vim.tbl_contains(filetypes, vim.bo.filetype)
        then
            buf_attach()
        end

        config.on_exit = vim.schedule_wrap(function(code, signal, client_id)
            vim.api.nvim_del_autocmd(autocmd)
        end)
end

-- Remote debugger configuration
require('dap').configurations.java = {
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        projectName = function()
            return vim.fn.input("Project Name: ")
        end,
--        projectName = "",
        hostName = "127.0.0.1",
        port = function()
            return vim.fn.input("Debug Port: ")
        end
    },
    {
        type = "java",
        request = "launch",
        name = "Debug (Launch)"
    }
}


-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
