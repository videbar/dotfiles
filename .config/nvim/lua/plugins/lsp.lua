return {
    "neovim/nvim-lspconfig",
    dependecies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
        local lsp = require("lspconfig")
        local builtin = require("telescope.builtin")

        -- Remaps available to all files.
        vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
        vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
        vim.keymap.set("n", "<leader>dl", builtin.diagnostics)

        -- Configuration available to all files with an lsp server set up.
        local function default_on_attach(client, buffnr)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
            vim.keymap.set("n", "gD", builtin.lsp_definitions, { buffer = 0 })
            vim.keymap.set("n", "gd", function()
                builtin.lsp_definitions({ jump_type = "vsplit" })
            end, { buffer = 0 })
            vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = 0 })
            vim.keymap.set("n", "gt", function()
                builtin.lsp_type_definitions({ jump_type = "vsplit" })
            end, { buffer = 0 })
            vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
            vim.keymap.set("i", "<C-h>", function()
                vim.lsp.buf.signature_help()
            end, opts)

            vim.lsp.inlay_hint.enable()
        end

        local handlers = {
            ["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover,
                { border = "rounded", max_width = 70 }
            ),
            ["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help,
                { border = "rounded", max_width = 70 }
            ),
        }

        lsp.pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { maxLineLength = vim.opt.textwidth:get() },
                    },
                },
            },
            handlers = handlers,
            on_attach = default_on_attach,
        })
        lsp.lua_ls.setup({ handlers = handlers, on_attach = default_on_attach })
        lsp.clangd.setup({ handlers = handlers, on_attach = default_on_attach })
        lsp.bashls.setup({ handlers = handlers, on_attach = default_on_attach })
        lsp.matlab_ls.setup({
            handlers = handlers,
            on_attach = default_on_attach,
            settings = {
                MATLAB = {
                    -- The lsp server expects matlab to be installed here. The
                    -- installation directory can be obtained using the matlab command
                    -- `matlabroot`.
                    installPath = vim.env.HOME .. "/.matlab",
                    telemetry = false,
                },
            },
        })
        lsp.texlab.setup({
            handlers = handlers,
            on_attach = default_on_attach,
            settings = {
                texlab = {
                    inlayHints = { labelReferences = false },
                    build = { onSave = true },
                },
            },
        })
        lsp.neocmake.setup({ handlers = handlers, on_attach = default_on_attach })
        lsp.rust_analyzer.setup({ handlers = handlers, on_attach = default_on_attach })
        lsp.taplo.setup({ handlers = handlers, on_attach = default_on_attach })

        vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })

        -- Toggle diagnostics with <leader>h. This may include elements from different
        -- plugins so I use a global list of functions that should be called. This list
        -- can be modified in a plugin config to add the appropriate functions.
        vim.keymap.set("n", "<leader>h", function()
            for _, f in ipairs(vim.g.ToggleDiagnosticsFuncs) do
                f()
            end
        end)
        -- Global tables are not mutable.
        local funcs = vim.g.ToggleDiagnosticsFuncs or {}
        funcs[#funcs + 1] = function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end
        funcs[#funcs + 1] = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end
        vim.g.ToggleDiagnosticsFuncs = funcs
    end,
}
