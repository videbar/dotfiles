return {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
        local tweaked_theme = require("lualine.themes.auto")
        for _, v in pairs(tweaked_theme) do
            -- Disable the bold text
            v.a.gui = ""
        end
        local my_opts = {
            options = {
                icons_enabled = false,
                theme = tweaked_theme,
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { statusline = {}, winbar = {} },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = { statusline = 40, tabline = 40, winbar = 40 },
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
                lualine_b = {
                    {
                        "diagnostics",
                        symbols = {
                            error = "● ",
                            warn = "● ",
                            info = "● ",
                            hint = "● ",
                        },
                    },
                },
                lualine_c = {
                    "branch",
                    {
                        "filename",
                        symbols = {
                            modified = "✱",
                            readonly = "🕮",
                            unnamed = "⦸",
                            newfile = "🞥",
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
        }
        return vim.tbl_deep_extend("force", opts, my_opts)
    end,
}
