local opts = {
  --   mappings = true,
  -- lsp = {
  --   on_attach = require("lvim.lsp").common_on_attach,
  --   on_init = require("lvim.lsp").common_on_init,
  --   on_exit = require("lvim.lsp").common_on_exit,
  --   capabilities = require("lvim.lsp").common_capabilities(),
  -- },
}
require("lvim.lsp.manager").setup("lean", opts)
