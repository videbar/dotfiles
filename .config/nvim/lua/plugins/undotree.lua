return {
    "mbbill/undotree",
    config = function(_, opts)
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
}
