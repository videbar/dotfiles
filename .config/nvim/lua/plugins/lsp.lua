return {
    "neovim/nvim-lspconfig",
    dependecies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
        local lsp = require("lspconfig")
        local builtin = require("telescope.builtin")
        -- Disable LSP snippets.
        lsp.util.default_config.capabilities.textDocument.completion.completionItem.snippetSupport =
            false

        -- Remaps available to all files.
        vim.keymap.set("n", "<leader>dn", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end)
        vim.keymap.set("n", "<leader>dp", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end)
        vim.keymap.set("n", "<leader>dl", builtin.diagnostics)

        -- Configuration available to all files with an lsp server set up.
        local function default_on_attach(client, buffnr)
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover({ border = "rounded", max_width = 70 })
            end, { buffer = 0 })

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
                vim.lsp.buf.signature_help({ border = "rounded", max_width = 70 })
            end, opts)

            vim.lsp.inlay_hint.enable()
        end

        lsp.pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { maxLineLength = vim.opt.textwidth:get() },
                    },
                },
            },
            on_attach = default_on_attach,
        })
        lsp.lua_ls.setup({ on_attach = default_on_attach })
        lsp.clangd.setup({ on_attach = default_on_attach })
        lsp.bashls.setup({ on_attach = default_on_attach })
        lsp.zls.setup({ on_attach = default_on_attach })
        lsp.matlab_ls.setup({
            on_attach = default_on_attach,
            -- If this is not set, the lsp will not attach to any buffer unless the
            -- files are in a git repository.
            single_file_support = true,
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
            on_attach = default_on_attach,
            settings = {
                texlab = {
                    inlayHints = { labelReferences = false },
                    build = { onSave = true },
                },
            },
        })
        lsp.neocmake.setup({ on_attach = default_on_attach })
        lsp.rust_analyzer.setup({ on_attach = default_on_attach })
        lsp.taplo.setup({ on_attach = default_on_attach })

        vim.diagnostic.config({
            virtual_text = true,
            float = { border = "rounded" },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "●",
                    [vim.diagnostic.severity.WARN] = "●",
                    [vim.diagnostic.severity.INFO] = "●",
                    [vim.diagnostic.severity.HINT] = "●",
                },
            },
        })

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
