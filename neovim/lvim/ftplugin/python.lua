local formatters = require "lvim.lsp.null-ls.formatters"

formatters.setup {
  { name = "black" },
}

require("lvim.lsp.manager").setup("pyright", {})
