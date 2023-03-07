local lsp = require("lsp-zero")
local cmp = require("cmp")

--
-- Lsp configuration.
--

lsp.preset({ name = "recommended", set_lsp_keymaps = true, manage_nvim_cmp = true })

lsp.ensure_installed({ "rust_analyzer", "pylsp" })

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<S-Tab>"] = nil
})

lsp.setup_nvim_cmp({ mapping = cmp_mappings })

-- Disable autocomplete in comments using cmp.
local cmp_enabled = cmp.get_config().enabled
local cmp_config = lsp.defaults.cmp_config({
    enabled = function()
        if require("cmp.config.context").in_treesitter_capture("comment") == true or
            require("cmp.config.context").in_syntax_group("Comment") then
            return false
        else
            return cmp_enabled()
        end
    end
})

--
-- Use null-ls for formatting.
--

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})

local null_ls_config = {
    on_attach = function(client, bufnr) null_opts.on_attach(client, bufnr) end,
    -- Formatting sources.
    sources = {
        null_ls.builtins.formatting.black, null_ls.builtins.formatting.lua_format.with({
        extra_args = { "--single-quote-to-double-quote", "--column-limit=88" }
    })
    }
}

null_ls.setup(null_ls_config)
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
end)

--
-- Configura rust tools
--

require("rust-tools").setup({
    tools = {
        server = rust_lsp,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = ""
        }
    }
})