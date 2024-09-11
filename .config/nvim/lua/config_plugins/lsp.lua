local lsp = require("lspconfig")
local builtin = require("telescope.builtin")

-- Remaps available to all files.
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>dl", builtin.diagnostics)

-- Configuration available to all files with an lsp server set up.
local function default_on_attach(client, buffnr)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
    vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { buffer = 0 })
    vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
    end, opts)

    vim.lsp.inlay_hint.enable()
end

lsp.pylsp.setup({ on_attach = default_on_attach })
lsp.lua_ls.setup({ on_attach = default_on_attach })
lsp.clangd.setup({ on_attach = default_on_attach })
lsp.bashls.setup({ on_attach = default_on_attach })
lsp.matlab_ls.setup({
    on_attach = default_on_attach,
    settings = {
        MATLAB = {
            -- The lsp server expects matlab to be installed here. The installation
            -- directory can be obtained using the matlab command `matlabroot`.
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

vim.diagnostic.config({ virtual_text = true })

-- Toggle virtual text with <leader>h.
vim.keymap.set("n", "<leader>h", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
