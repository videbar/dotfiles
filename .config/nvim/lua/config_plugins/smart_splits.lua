require("smart-splits").setup({
    resize_mode = {
        quit_key = "q",
    },
})

vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
vim.keymap.set("n", "<A-r>", require("smart-splits").start_resize_mode)
