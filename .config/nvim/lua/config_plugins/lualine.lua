local tweaked_theme = require("lualine.themes.auto")
tweaked_theme.normal.c.bg = require("tokyonight.colors.storm").bg

require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = tweaked_theme,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = function(res)
                    return res:lower()
                end,
            },
        },
        lualine_b = { "diagnostics" },
        lualine_c = {
            "branch",
            {
                "filename",
                symbols = {
                    modified = "●", -- Text to show when the file is modified.
                    readonly = "🕮", -- Text to show when the file is non-modifiable or readonly.
                    unnamed = "⦸", -- Text to show for unnamed buffers.
                    newfile = "🞥", -- Text to show for newly created file before first write
                },
            },
        },
        lualine_x = {
            function()
                if vim.g.format_on_save then
                    return "⋮🖫"
                else
                    return ""
                end
            end,
            function()
                if vim.opt.spell:get() then
                    return vim.opt.spelllang:get()[1]
                else
                    return ""
                end
            end,
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
})
