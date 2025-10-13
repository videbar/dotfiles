-- LSPs and diagnostics configuration
local builtin = require("telescope.builtin")

-- Remaps available to all files, independently of the LSP:
vim.keymap.set("n", "<leader>dn", function()
    vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "<leader>dp", function()
    vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "<leader>dl", builtin.diagnostics)

-- General configuration for all LSPs:

local function default_on_attach(client, buffnr)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "rounded", max_width = 70 })
    end, { buffer = 0 })

    vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
    vim.keymap.set("n", "gD", function()
        builtin.lsp_definitions({ jump_type = "vsplit" })
    end, { buffer = 0 })
    vim.keymap.set("n", "gT", builtin.lsp_type_definitions, { buffer = 0 })
    vim.keymap.set("n", "gt", function()
        builtin.lsp_type_definitions({ jump_type = "vsplit" })
    end, { buffer = 0 })
    vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
    vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help({
            title = "Title",
            border = "rounded",
            max_width = 70,
        })
    end, opts)

    vim.lsp.inlay_hint.enable()
end

vim.lsp.config("*", {
    capabilities = {
        textDocument = {
            completionItem = {
                -- Disable LSP's snippets, I bring my own.
                snippetSupport = false,
            },
        },
    },
    on_attach = default_on_attach,
})

vim.diagnostic.config({
    virtual_text = true,
    float = { border = "rounded" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.INFO] = "●",
            [vim.diagnostic.severity.HINT] = "●",
        },
    },
})

vim.opt.completeopt = { "menu", "menuone" }
-- Toggle diagnostics with <leader>h. This may include elements from different plugins
-- so I use a global list of functions that should be called. This list can be modified
-- in a plugin config to add the appropriate functions.
vim.keymap.set("n", "<leader>h", function()
    for _, f in ipairs(vim.g.ToggleDiagnosticsFuncs) do
        f()
    end
end)
-- Global tables are not mutable.
local funcs = vim.g.ToggleDiagnosticsFuncs or {}
funcs[#funcs + 1] = function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end
funcs[#funcs + 1] = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end
vim.g.ToggleDiagnosticsFuncs = funcs

-- Servers
local servers = {
    ["lua-language-server"] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = {
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
            ".git",
        },
    },
    ["python-lsp-server"] = {
        cmd = { "pylsp" },
        filetypes = { "python" },
        root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            ".git",
        },
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        -- These get annoying with f-strings.
                        ignore = { "E251", "E202" },
                        maxLineLength = vim.opt.textwidth:get(),
                    },
                },
            },
        },
    },
    ["clangd"] = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = {
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
            ".git",
        },
        capabilities = {
            offsetEncoding = { "utf-8", "utf-16" },
            textDocument = {
                completion = {
                    editsNearCursor = true,
                },
            },
        },
    },
    ["bash-language-server"] = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "bash", "sh" },
        root_markers = { ".git" },
        settings = {
            bashIde = {
                globPattern = "*@(.sh|.inc|.bash|.command)",
            },
        },
    },
    ["zls"] = {
        cmd = { "zls" },
        filetypes = { "zig", "zir" },
        root_markers = { "zls.json", "build.zig", ".git" },
        settings = {
            bashIde = {
                globPattern = "*@(.sh|.inc|.bash|.command)",
            },
        },
        workspace_required = false,
    },
    ["matlab-language-server"] = {
        cmd = { "matlab-language-server", "--stdio" },
        filetypes = { "matlab" },
        root_dir = function(bufnr, on_dir)
            local root_dir = vim.fs.root(bufnr, ".git")
            on_dir(root_dir or vim.fn.getcwd())
        end,
        -- If this is not set, the lsp will not attach to any buffer unless the files
        -- are in a git repository.
        single_file_support = true,
        settings = {
            MATLAB = {
                -- The lsp server expects matlab to be installed here. The installation
                -- directory can be obtained using the matlab command `matlabroot`.
                installPath = vim.env.HOME .. "/.matlab",
                telemetry = false,
                indexWorkspace = true,
                matlabConnectionTiming = "onStart",
            },
        },
    },
    ["texlab"] = {
        cmd = { "texlab" },
        filetypes = { "tex", "plaintex", "bib" },
        root_markers = {
            ".git",
            ".latexmkrc",
            "latexmkrc",
            ".texlabroot",
            "texlabroot",
            "Tectonic.toml",
        },
        settings = {
            texlab = {
                inlayHints = { labelReferences = false },
                bibtexFormatter = "texlab",
                build = {
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                    executable = "latexmk",
                    forwardSearchAfter = false,
                    onSave = true,
                },
                chktex = {
                    onEdit = false,
                    onOpenAndSave = false,
                },
                diagnosticsDelay = 300,
                formatterLineLength = vim.opt.textwidth:get(),
                forwardSearch = {
                    args = {},
                },
                latexFormatter = "latexindent",
                latexindent = {
                    modifyLineBreaks = false,
                },
            },
        },
    },
    ["neocmakelsp"] = {
        cmd = { "neocmakelsp", "--stdio" },
        filetypes = { "cmake" },
        root_markers = { ".git", "build", "cmake" },
    },
    ["rust-analyzer"] = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        capabilities = {
            experimental = {
                serverStatusNotification = true,
            },
        },
        before_init = function(init_params, config)
            -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
            if config.settings and config.settings["rust-analyzer"] then
                init_params.initializationOptions = config.settings["rust-analyzer"]
            end
        end,
    },
}

local to_enable = {}
for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    to_enable[#to_enable + 1] = name
end
vim.lsp.enable(to_enable)
