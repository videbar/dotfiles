return {
    "lewis6991/gitsigns.nvim",
    config = function(_, opts)
        local gitsigns = require("gitsigns")
        gitsigns.setup({
            on_attach = function(buffnr)
                vim.keymap.set("n", "<leader>gn", function()
                    gitsigns.nav_hunk("next")
                end)
                vim.keymap.set("n", "<leader>gp", function()
                    gitsigns.nav_hunk("prev")
                end)

                local funcs = vim.g.ToggleDiagnosticsFuncs or {}
                funcs[#funcs + 1] = gitsigns.toggle_signs
                vim.g.ToggleDiagnosticsFuncs = funcs
            end,
        })
    end,
}
