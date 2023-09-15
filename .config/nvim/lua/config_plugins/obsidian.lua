local obsidian = require("obsidian")

obsidian.setup({
    dir = "$HOME/.obsidian/main",

    -- Optional, completion.
    completion = {
        -- If using nvim-cmp, otherwise set to false
        nvim_cmp = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = false
    },

    -- Optional, key mappings.
    mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = require("obsidian.mapping").gf_passthrough()
    },

    -- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = true,

    -- Optional, customize the backlinks interface.
    backlinks = {
        -- The default height of the backlinks pane.
        height = 10,
        -- Whether or not to wrap lines.
        wrap = true
    },

    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "xdg-open", url }) -- linux
    end,

    -- Configure how to generate the filename from the note title.
    note_id_func = function(title)
        if title ~= nil then
            -- If title is given, transform it into valid file name.
            return title:gsub("[%*\"\\/<>:|%?]", ""):lower()
        else
            error("No valid name was given")
        end
    end,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,

    -- Optional, by default commands like `:ObsidianSearch` will attempt to use
    -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
    -- first one they find. By setting this option to your preferred
    -- finder you can attempt it first. Note that if the specified finder
    -- is not installed, or if it the command does not support it, the
    -- remaining finders will be attempted in the original order.
    finder = "telescope.nvim",

    -- Optional, determines whether to open notes in a horizontal split, a vertical split,
    -- or replacing the current buffer (default)
    -- Accepted values are "current", "hsplit" and "vsplit"
    open_notes_in = "current"

})
-- Remap to add a new note, using `vim.ui.input` to ask the name.
vim.keymap.set("n", "<leader>on", function()
    vim.ui.input({ prompt = "Note name > " }, function(input)
        if input ~= nil then vim.cmd("ObsidianNew " .. input) end
    end)
end)
vim.keymap.set("n", "<leader>of", vim.cmd.ObsidianQuickSwitch)
vim.keymap.set("n", "<leader>os", vim.cmd.ObsidianSearch)
