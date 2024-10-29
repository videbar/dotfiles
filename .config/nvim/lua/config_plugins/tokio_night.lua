local tokyonight = require("tokyonight")
tokyonight.setup({
    on_colors = function(colors)
        -- Change the color of the line between window splits.
        colors.border = colors.comment
    end,
    on_highlights = function(highlights, colors)
        -- Change the color of the colorcolumn.
        highlights.ColorColumn.bg = colors.bg_highlight
        highlights.NvimSurroundHighlight = { bg = colors.terminal_black }
        highlights.LspInlayHint.bg = nil
    end,
})
vim.cmd.colorscheme("tokyonight-night")
