local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local custom_split_actions = require("telescope.actions.mt").transform_mod({
    ver = function(prompt_bufnr)
        actions.select_vertical(prompt_bufnr)
        vim.cmd("wincmd L")
    end,
    hor = function(prompt_bufnr)
        actions.select_horizontal(prompt_bufnr)
        vim.cmd("wincmd J")
    end,
})

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-y>"] = actions.select_default,
                ["<C-s>"] = actions.select_horizontal,
            },
        },
    },
    extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown({}),
    },
    pickers = {
        spell_suggest = {
            mappings = {
                i = {
                    ["<C-v>"] = false,
                    ["<C-x>"] = false,
                    ["<C-s>"] = false,
                },
            },
        },
        help_tags = {
            mappings = {
                i = {
                    ["<C-y>"] = actions.select_vertical,
                    ["<CR>"] = actions.select_vertical,
                },
            },
        },
    },
})

-- Use telescope to show things like code actions.
telescope.load_extension("ui-select")

-- Telescope remaps
vim.keymap.set("n", "<leader>fp", function()
    builtin.find_files({
        hidden = true,
    })
end, {})

-- Use to find files that contain a string. Requires ripgrep.
vim.keymap.set("n", "<leader>gp", function()
    vim.ui.input({ prompt = "Grep > " }, function(input)
        if input ~= nil then
            builtin.grep_string({ search = input })
        end
    end)
end)

vim.keymap.set(
    "n",
    "<leader>ff",
    builtin.current_buffer_fuzzy_find,
    { sorting_strategy = ascending, prompt_position = top }
)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>ch", builtin.command_history, {})

-- Show spell check suggestions using telescope with <leader>sf (spell fix).
vim.keymap.set("n", "<leader>sf", function()
    builtin.spell_suggest(require("telescope.themes").get_cursor({}))
end, { desc = "Spelling Suggestions" })

-- Use telescope to integrate git.
vim.keymap.set("n", "<leader>gts", builtin.git_status, {})
vim.keymap.set("n", "<leader>gtl", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gtb", builtin.git_branches, {})
