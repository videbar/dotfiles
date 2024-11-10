require("rose-pine").setup({
    variant = "main",

    styles = {
        italic = false,
    },

    highlight_groups = {
        Comment = { italic = true },
    },
})

vim.opt.fillchars:append("eob: ")
vim.cmd("colorscheme rose-pine")
