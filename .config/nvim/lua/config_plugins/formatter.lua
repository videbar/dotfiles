-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in.
    filetype = {
        -- Formatter configurations for filetype "lua" go here and will be executed in
        -- order.
        lua = {
            -- "formatter.filetypes.lua" defines default configurations for the "lua"
            -- filetype
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
            -- "formatter.filetypes.python" defines default configurations for the
            -- "python" filetype.
            require("formatter.filetypes.python").black,
        },
        cpp = {
            -- "formatter.filetypes.cpp" defines default configurations for the "cpp"
            -- filetype.
            require("formatter.filetypes.cpp").clangformat,
            function()
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
            end,
        },

        -- Use the special "*" filetype for defining formatter configurations on any
        -- filetype.
        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

-- Autoformat on (after) save.
vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        -- Check if a formatter was configured.
        local formatters =
            require("formatter.util").get_available_formatters_for_ft(vim.bo.filetype)
        -- If no formatter is configured, try to use the LSP server instead.
        if #formatters == 0 then
            local lsp_servers = vim.lsp.buf_get_clients()
            for _, server in pairs(lsp_servers) do
                if server.server_capabilities.documentFormattingProvider then
                    vim.lsp.buf.format()
                    break
                end
            end
        end
        -- Either way, call `FormatWrite` so that the "any type" formatter is run.
        vim.cmd("FormatWrite")
    end,
})
