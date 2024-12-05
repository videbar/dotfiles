return {
    "stevearc/oil.nvim",
    opts = {
        columns = {
            { "type", icons = { link = "🔗", file = "📄", directory = "📁" } },
        },
        view_options = {
            show_hidden = true,
        },
    },
    config = function(_, otps)
        require("oil").setup(otps)
        vim.keymap.set("n", "<leader>vp", function()
            vim.cmd("Oil")
        end, { desc = "Open parent directory" })
    end,
}
