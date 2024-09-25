local harpoon = require("harpoon")
harpoon:setup({ settings = { save_on_toggle = true } })

vim.keymap.set("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list(), {
        title = " Harpoon ",
        border = "rounded",
        title_pos = "center",
        ui_max_width = 80,
    })
end)
vim.keymap.set("n", "<leader>ah", function()
    harpoon:list():add()
end)
vim.keymap.set("n", "<C-1>", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-2>", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-3>", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-4>", function()
    harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list.
vim.keymap.set("n", "<leader>ap", function()
    harpoon:list():prev()
end)
vim.keymap.set("n", "<leader>an", function()
    harpoon:list():next()
end)

-- Remaps in the harpoon menu.
harpoon:extend({
    UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-y>", function()
            harpoon.ui:select_menu_item({})
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-s>", function()
            harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })
    end,
})
