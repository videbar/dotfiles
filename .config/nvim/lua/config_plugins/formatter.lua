-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands

-- Used to define a common configuration for c and cpp.
local clang_format = function()
    return {
        exe = "clang-format",
        args = {
            [[--style="{
                BasedOnStyle: Google,
                IndentWidth: 4,
                ColumnLimit: 88,
                AlignAfterOpenBracket: Align,
                AlignTrailingComments: true
            }"]],
            "-i",
        },
    }
end
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations need to be enable, since they are opt-in.
    -- `formatter.filetypes.xxx` defines default configurations for the `xxx` filetype.
    filetype = {
        -- Formatter configurations for filetype "lua" go here and will be executed in
        -- order.
        lua = {
            require("formatter.filetypes.lua").stylua,

            -- If there's a config file, use that, otherwise use my own.
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
            require("formatter.filetypes.python").black,
        },
        c = {
            require("formatter.filetypes.c").clangformat,
            clang_format,
        },
        cpp = {
            require("formatter.filetypes.cpp").clangformat,
            clang_format,
        },
        -- Use the special "*" filetype for defining formatter configurations on any
        -- filetype.
        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

-- Autoformat on (after) save.
vim.g.format_on_save = true
vim.api.nvim_create_user_command("DisableFormatOnSave", function()
    vim.g.format_on_save = false
end, {})
vim.api.nvim_create_user_command("EnableFormatOnSave", function()
    vim.g.format_on_save = true
end, {})

vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        if vim.g.format_on_save then
            -- Check if a formatter was configured.
            local formatters =
                require("formatter.util").get_available_formatters_for_ft(
                    vim.bo.filetype
                )
            -- If no formatter is configured, try to use the LSP server instead.
            if #formatters == 0 then
                local lsp_servers = vim.lsp.buf_get_clients()
                for _, server in pairs(lsp_servers) do
                    if server.server_capabilities.documentFormattingProvider then
                        vim.lsp.buf.format({ timeout_ms = 2000 })
                        break
                    end
                end
            end
            -- Either way, call `FormatWrite` so that the "any type" formatter is run.
            vim.cmd("FormatWrite")
        end
    end,
})
