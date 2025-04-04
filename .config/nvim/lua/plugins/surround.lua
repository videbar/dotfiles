return {
    "kylechui/nvim-surround",
    opts = {
        surrounds = {
            -- Wikilinks e.g., [[link]]
            ["w"] = {
                add = { "[[", "]]" },
                find = function()
                    return require("nvim-surround.config").get_selection({
                        motion = "2a]",
                    })
                end,
                delete = "^(%[%[)().-(%]%])()$",
            },
            -- Markdown link from the system clipboard, e.g., [link](https://www.link.com)
            ["l"] = {
                add = function()
                    local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                    return {
                        { "[" },
                        { "](" .. clipboard .. ")" },
                    }
                end,
                find = "%b[]%b()",
                delete = "^(%[)().-(%]%b())()$",
                change = {
                    target = "^()()%b[]%((.-)()%)$",
                    replacement = function()
                        local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                        return {
                            { "" },
                            { clipboard },
                        }
                    end,
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-surround").setup(opts)

        -- Highlight the yanked text using the same group as surround.nvim
        vim.api.nvim_create_autocmd("TextYankPost", {
            callback = function()
                vim.hl.on_yank({
                    higroup = "NvimSurroundHighlight",
                    timeout = 250,
                })
            end,
        })
    end,
}
