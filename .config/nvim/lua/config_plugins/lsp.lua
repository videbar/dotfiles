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
    vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = 0 })
    vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
    vim.lsp.inlay_hint.enable()
end
lsp.pylsp.setup({ on_attach = default_on_attach })
lsp.lua_ls.setup({ on_attach = default_on_attach })
lsp.clangd.setup({ on_attach = default_on_attach })
lsp.texlab.setup({ on_attach = default_on_attach })
lsp.neocmake.setup({ on_attach = default_on_attach })
lsp.rust_analyzer.setup({ on_attach = default_on_attach })
lsp.ltex.setup({
    on_attach = default_on_attach,
    -- Select the natural language automatically, e.g., Spanish. This results in ltex
    -- not showing spelling suggestions, only grammar ones.
    settings = { ltex = { language = "auto" } },
})

vim.diagnostic.config({ virtual_text = true })
-- Toggle virtual text with <leader>h.
vim.g.diagnostics_visible = true
vim.keymap.set("n", "<leader>h", function()
    if vim.g.diagnostics_visible then
        vim.diagnostic.disable()
        vim.g.diagnostics_visible = false
    else
        vim.diagnostic.enable()
        vim.g.diagnostics_visible = true
    end
    -- Toggle the inlay hints.
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
end)

-- vim.lsp.buf.format()
