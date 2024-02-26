local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
    extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown({}),
    },
})

-- Use telescope to show things like code actions.
telescope.load_extension("ui-select")

vim.keymap.set("n", "<leader>pf", function()
    builtin.find_files({
        hidden = true,
    })
end, {})
-- Use to find files that contain a string. Requires ripgrep.
vim.keymap.set("n", "<leader>ps", function()
    vim.ui.input({ prompt = "Grep > " }, function(input)
        if input ~= nil then
            builtin.grep_string({ search = input })
        end
    end)
end)

-- Use telescope to integrate git.
vim.keymap.set("n", "<leader>gts", builtin.git_status, {})
vim.keymap.set("n", "<leader>gtl", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gtb", builtin.git_branches, {})

-- Other useful remaps.
vim.keymap.set(
    "n",
    "<leader>fi",
    builtin.current_buffer_fuzzy_find,
    { sorting_strategy = ascending, prompt_position = top }
)
vim.keymap.set("n", "<leader>ch", builtin.command_history, {})

-- Show spell check suggestions using telescope with <leader>sf (spell fix).
vim.keymap.set("n", "<leader>sf", function()
    builtin.spell_suggest(require("telescope.themes").get_cursor({}))
end, { desc = "Spelling Suggestions" })

-- Setup remaps to change the language of the spellchecker.
vim.keymap.set("n", "<leader>sg", function()
    vim.opt.spelllang = "en"
    vim.opt.spell = true
    print("Spell check set to English")
end)

vim.keymap.set("n", "<leader>se", function()
    vim.opt.spelllang = "es"
    vim.opt.spell = true
    print("Spell check set to Spanish")
end)
