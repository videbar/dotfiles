require("catppuccin").setup({
    flavour = "mocha",
    color_overrides = {
        mocha = {
            base = "#1a1a1a",
            mantle = "#000000",
            crust = "#000000",
        },
    },
    styles = {
        comments = { "italic" },
        conditionals = {},
    },
    custom_highlights = function(colors)
        return {
            CmpSelect = { bg = colors.surface0 },
            WinSeparator = { fg = colors.sapphire },
        }
    end,
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = false,
        treesitter = true,
    },
})
vim.cmd.colorscheme("catppuccin")

-- Customise the highlight groups

local err_hl = vim.api.nvim_get_hl(0, { name = "ErrorMsg" })
err_hl.italic = false
vim.api.nvim_set_hl(0, "ErrorMsg", err_hl)

local normal_float_hl = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
normal_float_hl.bg = nil
vim.api.nvim_set_hl(0, "NormalFloat", normal_float_hl)
