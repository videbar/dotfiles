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

-- Set the column that indicates the line length.
vim.opt.colorcolumn = "88"

-- Enable cursor line.
vim.opt.cursorline = true

-- Autoformat on save.
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Keep current line always in the center. This is done using an autocmd instead of the
-- scroll option to make it work at the bottom of the document.
function Center_cursor()
    local pos = vim.fn.getpos(".")
    vim.cmd("normal! zz")
    vim.fn.setpos(".", pos)
end

vim.cmd [[autocmd CursorMoved,CursorMovedI * lua Center_cursor()]]

-- Use treesitter for code folding.
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Workaround to avoid a bug in telescope. It prevents a file that has been opened with
-- telescope from folding:
-- https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.cmd [[autocmd BufEnter * normal zx zR]]
