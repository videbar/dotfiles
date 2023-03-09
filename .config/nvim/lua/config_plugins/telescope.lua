local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})

vim.keymap.set("n", "<C-f>", builtin.current_buffer_fuzzy_find,
    { sorting_strategy = ascending, prompt_position = top })

-- Use to find files that contain a string. Requires ripgrep.
vim.keymap.set("n", "<leader>ps",
    function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)
