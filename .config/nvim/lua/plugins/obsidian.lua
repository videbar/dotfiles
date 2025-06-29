local obsidian_path = vim.env.HOME .. "/.obsidian"
return {
    "epwalsh/obsidian.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Only load this plugin if the vault folder exists.
    enabled = function()
        local vault = io.open(obsidian_path, "r")
        if vault == nil then
            return false
        else
            io.close(vault)
            return true
        end
    end,
    opts = {
        -- A list of workspace names, paths, and configuration overrides. If you use the
        -- Obsidian app, the 'path' of a workspace should generally be your vault root
        -- (where the `.obsidian` folder is located). When obsidian.nvim is loaded by
        -- your plugin manager, it will automatically set the workspace to the first
        -- workspace in the list whose `path` is a parent of the current markdown file
        -- being edited.
        workspaces = { { name = "main", path = obsidian_path .. "/main" } },

        ui = {
            enable = false,
        },
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = false,

        -- Whether to add the note path during completion. E.g. "[[Foo" completes to
        -- "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note. Mutually
        -- exclusive with 'prepend_note_id' and 'use_path_only'.
        prepend_note_path = false,

        -- Whether to only use paths during completion. E.g. "[[Foo" completes to
        -- "[[notes/foo]]" assuming "notes/foo.md" is the path of the note. Mutually
        -- exclusive with 'prepend_note_id' and 'prepend_note_path'.
        use_path_only = true,

        -- Optional, completion.
        completion = {
            -- If using nvim-cmp, otherwise set to false
            nvim_cmp = true,
            -- Trigger completion at 2 chars
            min_chars = 2,
        },

        -- Either 'wiki' or 'markdown'.
        preferred_link_style = "wiki",

        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or
            -- 'mini.pick'.
            name = "telescope.nvim",
            -- Optional, configure key mappings for the picker. These are the defaults.
            -- Not all pickers support all mappings.
        },
        wiki_link_func = "use_path_only",
        -- Optional, key mappings.
        mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your
            -- vault.
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
        },

        -- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
        disable_frontmatter = true,
        -- Configure how to generate the filename from the note title.
        note_id_func = function(title)
            if title ~= nil then
                return title:gsub('[%*"\\/<>:|%?]', ""):gsub(" ", "_"):lower()
            else
                error("No valid name was given")
            end
        end,

        attachments = {
            -- The default folder to place images in via `:ObsidianPasteImg`. If this is
            -- a relative path it will be interpreted as relative to the vault root.
            img_folder = "attachments",

            -- Customize the default name or prefix when pasting images via
            -- `:ObsidianPasteImg`.
            img_name_func = function()
                -- Prefix image names with timestamp.
                return string.format("%s-", os.time())
            end,

            -- A function that determines the text to insert in the note when pasting an
            -- image. It takes two arguments, the `obsidian.Client` and an
            -- `obsidian.Path` to the image file.
            img_text_func = function(client, path)
                path = client:vault_relative_path(path) or path
                return string.format("[%s](%s)", path.name, path)
            end,
        },

        -- Optional, set to true to force ':ObsidianOpen' to bring the app to the
        -- foreground.
        open_app_foreground = false,

        -- Optional, by default commands like `:ObsidianSearch` will attempt to use
        -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
        -- first one they find. By setting this option to your preferred
        -- finder you can attempt it first. Note that if the specified finder
        -- is not installed, or if it the command does not support it, the
        -- remaining finders will be attempted in the original order.
        finder = "telescope.nvim",

        -- Optional, determines whether to open notes in a horizontal split, a vertical
        -- split, or replacing the current buffer (default) Accepted values are
        -- "current", "hsplit" and "vsplit"
        open_notes_in = "current",
    },
    config = function(_, opts)
        require("obsidian").setup(opts)
        vim.keymap.set("n", "<leader>fo", vim.cmd.ObsidianQuickSwitch)
        vim.keymap.set("n", "<leader>ol", vim.cmd.ObsidianBacklinks)
        vim.keymap.set("n", "<leader>oo", vim.cmd.ObsidianOpen)
        vim.keymap.set("n", "<leader>oi", vim.cmd.ObsidianPasteImg)

        vim.keymap.set("n", "<leader>orn", function()
            vim.ui.input({ prompt = "New name > " }, function(input)
                if input ~= nil then
                    vim.cmd.ObsidianRename(
                        input:gsub('[%*"\\/<>:|%?]', ""):gsub(" ", "_"):lower()
                    )
                end
            end)
        end)
    end,
}
