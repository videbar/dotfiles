local cmp = require("cmp")

cmp.setup({
    performance = { max_view_entries = 10 },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Select,
            select = true,
        }),
        ["<C-S>"] = cmp.mapping.complete(),
    },
    sources = {
        -- Sources used by cmp to provide completion. The order in which they are
        -- provided is important, the sources that are closer to the start of the table
        -- have a higher priority.
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        -- `keyword_length` is used to configured the minimum number of characters that
        -- need to be typed before showing a suggestion from this source.
        { name = "buffer", keyword_length = 5 },
    },

    experimental = { native_menu = false },
})
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

