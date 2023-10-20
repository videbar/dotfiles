local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})

vim.keymap.set(
    "n",
    "<C-f>",
    builtin.current_buffer_fuzzy_find,
    { sorting_strategy = ascending, prompt_position = top }
)

-- Use to find files that contain a string. Requires ripgrep.
vim.keymap.set("n", "<leader>ps", function()
    vim.ui.input({ prompt = "Grep > " }, function(input)
        if input ~= nil then
            builtin.grep_string({ search = input })
        end
    end)
end)

-- Show spell check suggestions using telescope with <leader>sp (spell fix).
vim.keymap.set("n", "<leader>sf", function()
    require("telescope.builtin").spell_suggest(
        require("telescope.themes").get_cursor({})
    )
end, { desc = "Spelling Suggestions" })

-- Setup remaps to change the language of the spellchecker.
vim.keymap.set("n", "<leader>sg", function()
    vim.o.spelllang = "en"
    vim.opt.spell = true
    print("Spell check set to English")
end)

vim.keymap.set("n", "<leader>se", function()
    vim.o.spelllang = "es"
    vim.opt.spell = true
    print("Spell check set to Spanish")
end)
