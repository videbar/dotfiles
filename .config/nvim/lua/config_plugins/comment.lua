-- Ignore empty lines and toggle commented lines with <C-n>.
require("Comment").setup({
    ignore = "^$",
    toggler = { line = "<C-n>" },
    opleader = { line = "<C-n>" }
})
