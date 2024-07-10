require("oil").setup({
    columns = {
        { "type", icons = { link = "🔗", file = "📄", directory = "📁" } },
    },
    view_options = {
        show_hidden = true,
    },
})

-- Open parent directory in current window.
vim.keymap.set("n", "<leader>vp", "<CMD>Oil<CR>", { desc = "Open parent directory" })
