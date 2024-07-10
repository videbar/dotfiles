-- Move entire lines when selected.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- When using J to append the next line to the current line, keep the cursor in place.
vim.keymap.set("n", "J", "mzJ`z")

-- Use <leader>p to paste on a selected text without losing the original copied text.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Use <leader>d to delete a selected text without copying it to the paste buffer.
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Use <leader>y to copy text to the system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Remap <C-c> to the escape key so that vertical editing works properly.
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Use <leader>s to replace the current word.
vim.keymap.set(
    "n",
    "<leader>rw",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)

-- Toggle spell check.
vim.keymap.set("n", "<leader>ss", function()
    if vim.opt.spell:get() then
        vim.opt.spell = false
    else
        vim.opt.spell = true
    end
end)

-- Setup remaps to change the language of the spellchecker.
vim.keymap.set("n", "<leader>sg", function()
    vim.opt.spelllang = "en"
    vim.opt.spell = true
end)

vim.keymap.set("n", "<leader>se", function()
    vim.opt.spelllang = "es"
    vim.opt.spell = true
end)

-- Window resizing.
vim.keymap.set("n", "<M-l>", function()
    vim.cmd("wincmd >")
end)
vim.keymap.set("n", "<M-h>", function()
    vim.cmd("wincmd <")
end)
vim.keymap.set("n", "<M-j>", function()
    vim.cmd("wincmd +")
end)
vim.keymap.set("n", "<M-k>", function()
    vim.cmd("wincmd -")
end)
