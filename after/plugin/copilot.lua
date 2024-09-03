local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    FixError = "Please explain the error in the following text and provide a solution.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
}

local chat = require("CopilotChat")
local select = require("CopilotChat.select")

local opts = {
    question_header = "## User ",
    answer_header = "## Copilot ",
    error_header = "## Error ",
    prompts = prompts,
    auto_follow_cursor = false,
    show_help = false,
    mappings = {
        complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
        },
        close = {
            normal = "q",
            insert = "<C-c>",
        },
        reset = {
            normal = "<C-x>",
            insert = "<C-x>",
        },
        submit_prompt = {
            normal = "<CR>",
            insert = "<C-CR>",
        },
        accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>",
        },
        yank_diff = {
            normal = "gmy",
        },
        show_diff = {
            normal = "gmd",
        },
        show_system_prompt = {
            normal = "gmp",
        },
        show_user_selection = {
            normal = "gms",
        },
    },
}

opts.selection = select.unnamed
opts.prompts.Commit = {
    prompt = "Write commit message for the change with commitizen convention",
    selection = select.gitdiff,
}
opts.prompts.CommitStaged = {
    prompt = "Write commit message for the change with commitizen convention",
    selection = function(source)
        return select.gitdiff(source, true)
    end,
}

chat.setup(opts)
require("CopilotChat.integrations.cmp").setup()

vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
    chat.ask(args.args, { selection = select.visual })
end, { nargs = "*", range = true })

vim.api.nvim_create_user_command("CopilotChatInline", function(args)
    chat.ask(args.args, {
        selection = select.visual,
        window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
        },
    })
end, { nargs = "*", range = true })

vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
    chat.ask(args.args, { selection = select.buffer })
end, { nargs = "*", range = true })

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-*",
    callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true

        local ft = vim.bo.filetype
        if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
        end
    end,
})

local wk = require("which-key")
wk.register({
    ["<leader>gm"] = { name = "+Copilot Chat" },
    ["<leader>gmd"] = { "Show diff" },
    ["<leader>gmp"] = { "System prompt" },
    ["<leader>gms"] = { "Show selection" },
    ["<leader>gmy"] = { "Yank diff" },
})

vim.api.nvim_set_keymap("n", "<leader>ah", [[<cmd>lua require('CopilotChat.actions').help_actions()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ap", [[<cmd>lua require('CopilotChat.actions').prompt_actions()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>ap", [[:lua require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ae", [[<cmd>CopilotChatExplain<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>at", [[<cmd>CopilotChatTests<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ar", [[<cmd>CopilotChatReview<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>aR", [[<cmd>CopilotChatRefactor<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>an", [[<cmd>CopilotChatBetterNamings<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>av", [[:CopilotChatVisual<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>ax", [[:CopilotChatInline<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ai", [[:lua require('CopilotChat').ask(vim.fn.input('Ask Copilot: '))<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>am", [[<cmd>CopilotChatCommit<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>aM", [[<cmd>CopilotChatCommitStaged<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>aq", [[:lua require('CopilotChat').ask(vim.fn.input('Quick Chat: '), { selection = require('CopilotChat.select').buffer })<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ad", [[<cmd>CopilotChatDebugInfo<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>af", [[<cmd>CopilotChatFixDiagnostic<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>al", [[<cmd>CopilotChatReset<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>av", [[<cmd>CopilotChatToggle<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>a?", [[<cmd>CopilotChatModels<cr>]], { noremap = true, silent = true })

