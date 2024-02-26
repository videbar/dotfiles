-- Packer plugins
return require("packer").startup(function(use)
    -- Packer can manage itself.
    use("wbthomason/packer.nvim")

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        -- or                          , branch = '0.1.x',
        requires = { { "nvim-lua/plenary.nvim" } },
    })

    -- The Tokyo Night theme
    use("folke/tokyonight.nvim")

    -- Treesitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    -- Treesitter context
    use("nvim-treesitter/nvim-treesitter-context")

    -- Undotree
    use("mbbill/undotree")

    -- Language server protocol
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" }, -- Required
            { "williamboman/mason.nvim" }, -- Optional
            { "williamboman/mason-lspconfig.nvim" }, -- Optional
            -- Autocompletion
            { "hrsh7th/nvim-cmp" }, -- Required
            { "hrsh7th/cmp-nvim-lsp" }, -- Required
            { "hrsh7th/cmp-buffer" }, -- Optional
            { "hrsh7th/cmp-path" }, -- Optional
            { "saadparwaiz1/cmp_luasnip" }, -- Optional
            { "hrsh7th/cmp-nvim-lua" }, -- Optional
            -- Snippets
            { "L3MON4D3/LuaSnip" }, -- Required
            { "rafamadriz/friendly-snippets" }, -- Optional
            -- Formatting
            { "jose-elias-alvarez/null-ls.nvim" },
        },
    })

    -- Obsidian
    use({
        "epwalsh/obsidian.nvim",
        requires = {
            -- Required.
            "nvim-lua/plenary.nvim",
        },
    })

    -- Harpoon
    use({ "ThePrimeagen/harpoon", requires = { "nvim-lua/plenary.nvim" } })
    -- Inlay hints
    use("lvimuser/lsp-inlayhints.nvim")

    -- Comment
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Toggleterm
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup()
        end,
    })

    -- Lualine
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- Autopairs
    use("windwp/nvim-autopairs")

    -- Surround
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup()
        end,
    })

    -- Lastplace
    use("farmergreg/vim-lastplace")

    -- Formatter
    use({ "mhartington/formatter.nvim" })
end)
