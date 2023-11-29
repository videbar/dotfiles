-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        -- Formatter configurations for filetype "lua" go here and will be executed in order
        lua = {
            -- "formatter.filetypes.lua" defines default configurations for the "lua" filetype
            require("formatter.filetypes.lua").stylua,

            -- You can also define your own configuration
            function()
                local vconfig = vim.fn.glob("stylua.toml")
                local hconfig = vim.fn.glob(".stylua.toml")

                local args = {
                    "--indent-type",
                    "Spaces",
                    "--column-width",
                    88,
                    "-",
                }

                if vconfig ~= "" and hconfig == "" then
                    local cwd = vim.fn.getcwd()
                    args = { "--config-path", cwd .. "/" .. vconfig, "-" }
                end
                if hconfig ~= "" and vconfig == "" then
                    local cwd = vim.fn.getcwd()
                    args = { "--config-path", cwd .. "/" .. hconfig, "-" }
                end
                return {
                    exe = "stylua",
                    args = args,
                    stdin = true,
                }
            end,
        },
        python = {
            -- "formatter.filetypes.lua" defines default configurations for the "lua"
            -- filetype
            require("formatter.filetypes.python").black,
        },
        cpp = {
            -- "formatter.filetypes.cpp" defines default configurations for the "cpp"
            -- filetype
            require("formatter.filetypes.cpp").clangformat,
            function()
                return {
                    exe = "clang-format",
                    args = {
                        [[--style='{
                            BasedOnStyle: Google,
                            IndentWidth: 4,
                            AlignAfterOpenBracket: BlockIndent,
                            ColumnLimit: 88,
                        }']],
                        "-i",
                    },
                }
            end,
        },

        -- Use the special "*" filetype for defining formatter configurations on any
        -- filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

vim.keymap.set("n", "<leader>z", function()
    print("control")
    local cwd = vim.fn.getcwd()
    local wd = cwd .. "**stylua.toml"
    local config_files = vim.fn.glob(wd)
    print(config_files)
end)
