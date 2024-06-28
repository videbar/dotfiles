-- Set leader key to space.
vim.g.mapleader = " "

-- Enable line numbers
vim.opt.nu = true

-- Enable relative line numbers.
vim.opt.relativenumber = true

-- Change indententation to be 4 spaces.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Disable swap files and use an undodir instead.
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't highlight all results after a search.
vim.opt.hlsearch = false

-- Enable incremental searching.
vim.opt.incsearch = true

-- Terminal coloring.
vim.opt.termguicolors = true

-- How often vim checks if something is going on with the file (in milliseconds).
vim.opt.updatetime = 50

-- Set the column that indicates the line length. Use relative values to handle rust's
-- text width.
vim.opt.textwidth = 88
vim.opt.colorcolumn = "+1"

-- Enable cursor line.
vim.opt.cursorline = true

-- Keep current line always in the centered. This is done using an autocmd instead of
-- the scroll option to make it work at the bottom of the document.
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = function()
        local pos = vim.fn.getpos(".")
        vim.cmd("normal! zz")
        vim.fn.setpos(".", pos)
    end,
})

-- These make the previous autocmd work with mouse scrolling.
vim.keymap.set({ "n", "i", "v" }, "<ScrollWheelUp>", function()
    local _, _, ver_scroll = string.find(vim.opt.mousescroll:get()[1], "ver:(%d*)")
    vim.cmd("normal! " .. ver_scroll .. "k")
end)

vim.keymap.set({ "n", "i", "v" }, "<ScrollWheelDown>", function()
    local _, _, ver_scroll = string.find(vim.opt.mousescroll:get()[1], "ver:(%d*)")
    vim.cmd("normal! " .. ver_scroll .. "j")
end)

-- Use treesitter for code folding.
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- List of options: https://neovim.io/doc/user/change.html#fo-table
vim.opt.formatoptions = "jql"

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.bo[args.buf].formatexpr = nil
    end,
})

vim.opt.splitbelow = true
vim.opt.splitright = true
