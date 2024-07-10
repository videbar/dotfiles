require("oil").setup({
    columns = {
        { "type", icons = { link = "🔗", file = "📄", directory = "📁" } },
    },
    view_options = { show_hidde = true },
})

-- Open parent directory in current window
vim.keymap.set("n", "<leader>vp", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Open parent directory in floating window
-- vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
