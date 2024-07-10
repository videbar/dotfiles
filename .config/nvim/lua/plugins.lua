-- Packer plugins
return require("packer").startup(function(use)
    -- Packer can manage itself.
    use("wbthomason/packer.nvim")

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
    })

    -- The Tokyo Night theme
    use("folke/tokyonight.nvim")

    -- Treesitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    -- Treesitter context
    use("nvim-treesitter/nvim-treesitter-context")

    -- Undotree
    use("mbbill/undotree")

    -- Mason
    use("williamboman/mason.nvim")

    -- Lsp config
    use("neovim/nvim-lspconfig")

    -- Cmp
    use({
        "hrsh7th/nvim-cmp",
        -- Nvim-cmp sources.
        requires = {
            -- Autocomplete the current buffer
            "hrsh7th/cmp-buffer",
            -- Autocomplete paths.
            "hrsh7th/cmp-path",
            -- Autocomplete the nvim lua api.
            "hrsh7th/cmp-nvim-lua",
            -- Integrate with the nvim lsp client.
            "hrsh7th/cmp-nvim-lsp",
            -- Luansip sources
            "saadparwaiz1/cmp_luasnip",
        },
    })

    -- Snippets
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*",
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

    -- Comment
    use("numToStr/Comment.nvim")

    -- Lualine
    use("nvim-lualine/lualine.nvim")

    -- Autopairs
    use("windwp/nvim-autopairs")

    -- Surround
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    })

    -- Lastplace
    use("farmergreg/vim-lastplace")

    -- Formatter
    use("mhartington/formatter.nvim")

    -- Beter ai
    use("echasnovski/mini.ai")

    -- Smart splits
    use("mrjones2014/smart-splits.nvim")

    -- Oil
    use("stevearc/oil.nvim")
end)
