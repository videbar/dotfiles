return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Autocomplete using text from the current buffer.
        "hrsh7th/cmp-buffer",
        -- Autocomplete paths.
        "hrsh7th/cmp-path",
        -- Autocomplete the nvim lua api.
        "hrsh7th/cmp-nvim-lua",
        -- Integrate with the nvim lsp client.
        "hrsh7th/cmp-nvim-lsp",
        -- Luansip sources.
        "saadparwaiz1/cmp_luasnip",
        -- Autoclose operators on completion.
        "windwp/nvim-autopairs",
    },
    config = function(_, opts)
        -- Define the opts here, since they need to import the plugin.
        local my_opts = {
            performance = { max_view_entries = 10 },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "CursorLine:CmpSelect",
                },
                documentation = {
                    border = "rounded",
                },
            },
            mapping = {
                ["<C-p>"] = require("cmp").mapping.select_prev_item(),
                ["<C-n>"] = require("cmp").mapping.select_next_item(),
                ["<C-u>"] = require("cmp").mapping.scroll_docs(-4),
                ["<C-d>"] = require("cmp").mapping.scroll_docs(4),
                ["<C-e>"] = require("cmp").mapping.close(),
                ["<C-y>"] = require("cmp").mapping.confirm({ select = true }),
                ["<C-S>"] = require("cmp").mapping.complete(),
            },
            sources = {
                -- Sources used by cmp to provide completion. The order in which they are
                -- provided is important, the sources that are closer to the start of the
                -- table have a higher priority.
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
                -- `keyword_length` is used to configured the minimum number of characters
                -- that need to be typed before showing a suggestion from this source.
                { name = "buffer", keyword_length = 5 },
            },
            experimental = { native_menu = false },
        }
        require("cmp").setup(vim.tbl_deep_extend("force", opts, my_opts))
        require("cmp").event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done()
        )
    end,
}
