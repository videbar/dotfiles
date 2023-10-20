local lsp = require("lsp-zero")
local cmp = require("cmp")
local hints = require("lsp-inlayhints")

--
-- Lsp configuration.
--

lsp.preset({ name = "recommended", set_lsp_keymaps = true, manage_nvim_cmp = true })

lsp.ensure_installed({ "rust_analyzer", "pylsp", "lua_ls" })

lsp.configure(
    "pylsp",
    { settings = { pylsp = { plugins = { pycodestyle = { maxLineLength = 88 } } } } }
)

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<S-Tab>"] = nil,
})

-- Include parenthesis and similar delimiters when using autocomplete.
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

lsp.setup_nvim_cmp({ mapping = cmp_mappings })

-- Disable autocomplete in comments using cmp.
local cmp_enabled = cmp.get_config().enabled
local cmp_config = lsp.defaults.cmp_config({
    enabled = function()
        if
            require("cmp.config.context").in_treesitter_capture("comment") == true
            or require("cmp.config.context").in_syntax_group("Comment")
        then
            return false
        else
            return cmp_enabled()
        end
    end,
})

-- Lsp keybindings
lsp.on_attach(function(client, bufnr)
    hints.on_attach(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = true })
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end)

-- Inlay hints
hints.setup()
cmp.setup(cmp_config)
lsp.setup()

--
-- Diagnostics configuration.
--

-- Enable virtual text for diagnostics.
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
    hints.toggle()
end)
