-- Open the file explorer:
vim.keymap.set("n", "<leader>vp", vim.cmd.Ex)

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
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Toggle spell check with <C-s>.
vim.keymap.set("n", "<C-s>", function()
    if vim.opt.spell:get() then
        vim.opt.spell = false
        print("Spell check off")
    else
        vim.opt.spell = true
        print("Spell check on")
    end
end)
