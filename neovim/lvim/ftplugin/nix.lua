local null_ls = require("null-ls")
local sources = { null_ls.builtins.formatting.nixpkgs_fmt }
null_ls.setup({ sources = sources })
