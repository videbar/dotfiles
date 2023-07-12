-- Kemaps to send text to the terminal.
vim.keymap.set("n", "<leader>g", [[<Cmd>ToggleTermSendCurrentLine<CR>]])
vim.keymap.set("v", "<leader>g", ":ToggleTermSendVisualSelection<CR>",
    { noremap = true, silent = true })

require("toggleterm").setup {
    open_mapping = "<C-g>",
    -- when neovim changes it current directory the terminal will change it's own when
    -- next it's opened.
    autochdir = true,
    start_in_insert = true,
    -- whether or not the open mapping applies in insert mode.
    insert_mappings = false,
    -- whether or not the open mapping applies in the opened terminals. Required to be
    -- able to close terminals.
    terminal_mappings = true,
    persist_size = true,
    -- if set to true (default) the previous terminal mode will be remembered.
    persist_mode = false,
    direction = "float",
    -- close the terminal window when the process exits.
    close_on_exit = true,
    -- automatically scroll to the bottom on terminal output.
    auto_scroll = true
}
