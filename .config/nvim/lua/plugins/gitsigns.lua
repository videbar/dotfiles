return {
    "lewis6991/gitsigns.nvim",
    opts = {
        on_attach = function(buffnr)
            vim.keymap.set("n", "<leader>gn", function()
                gitsigns.nav_hunk("next")
            end)
            vim.keymap.set("n", "<leader>gp", function()
                gitsigns.nav_hunk("prev")
            end)
            vim.keymap.set("n", "<leader>h", function()
                ToggleAllDiagnostics()
                gitsigns.toggle_signs()
            end)
        end,
    },
}
