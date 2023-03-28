-- Set remaps to be able to switch windows in terminal mode.
vim.keymap.set("t", "<C-w>h", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-w>j", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-w>k", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-w>l", [[<Cmd>wincmd l<CR>]])
vim.keymap.set("t", "<C-w>w", [[<Cmd>wincmd w<CR>]])

-- Open and close terminals.
vim.keymap.set({ "t", "n" }, "<C-g>", [[<Cmd>ToggleTerm direction=horizontal<CR>]])
-- Open a vertical terminal:
-- vim.keymap.set("n", "<leader>x", [[<Cmd>ToggleTerm direction=vertical<CR>]])

-- Kemaps to send text to the terminal.
vim.keymap.set("n", "<leader>g", [[<Cmd>ToggleTermSendCurrentLine<CR>]])
vim.keymap.set("v", "<leader>g", ":ToggleTermSendVisualSelection<CR>",
    { noremap = true, silent = true })

require("toggleterm").setup {
    -- Define size differently depending on the type of terminal.
    size = function(term)
        if term.direction == "horizontal" then
            return vim.o.lines * 0.3
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.35
        end
    end,
    hide_numbers = true, -- hide the number column in toggleterm buffers
    autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    shading_factor = "-10",
    start_in_insert = true,
    persist_size = true,
    persist_mode = false, -- if set to true (default) the previous terminal mode will be remembered
    close_on_exit = true, -- close the terminal window when the process exits
    auto_scroll = true -- automatically scroll to the bottom on terminal output
}
