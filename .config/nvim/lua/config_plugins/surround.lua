require("nvim-surround").setup({
    surrounds = {
        -- Wikilinks e.g., [[link]]
        ["w"] = {
            add = { "[[", "]]" },
            find = function()
                return require("nvim-surround.config").get_selection({ motion = "2a]" })
            end,
            delete = "^(%[%[)().-(%]%])()$",
        },
    },
})
