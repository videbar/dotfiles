return {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function(_, opts)
        local my_opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<C-y>"] = require("telescope.actions").select_default,
                        ["<C-s>"] = require("telescope.actions").select_horizontal,
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
                            ["<C-y>"] = require("telescope.actions").select_vertical,
                            ["<CR>"] = require("telescope.actions").select_vertical,
                        },
                    },
                },
            },
        }
        -- Define the opts here, since they need to import the plugin.
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup(vim.tbl_deep_extend("force", opts, my_opts))

        -- Use telescope to show things like code actions.
        telescope.load_extension("ui-select")

        -- Telescope remaps
        vim.keymap.set("n", "<leader>fp", function()
            builtin.find_files({
                hidden = true,
            })
        end, {})

        -- Use to find files that contain a string. Requires ripgrep.
        vim.keymap.set("n", "<leader>gip", function()
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
        vim.keymap.set("n", "<leader>lv", builtin.treesitter, {})

        -- Show spell check suggestions using telescope with <leader>sf (spell fix).
        vim.keymap.set("n", "<leader>sf", function()
            builtin.spell_suggest(require("telescope.themes").get_cursor({}))
        end, { desc = "Spelling Suggestions" })
    end,
}
