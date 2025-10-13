-- General configuration.
require("config")

-- Key remaps.
require("remaps")

-- Load and configure Lazy plugins.
require("lazy_config")

-- Configure the LSPs and diagnostics; it should be sourced after the plugins since it
-- uses Telescope.
require("lsp")
