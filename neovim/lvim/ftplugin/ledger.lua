-- which_key {

local wk = require("which-key")

wk.register({
  ["L"] = {
    name = "hledger",
    b = { "<cmd>!hledger bs --pretty<cr>", "Balance Sheet" },
    i = { "<cmd>!hledger is --pretty --color y -p 'weekly from 3 weeks ago' not:acct:tax not:acct:family acct:expenses<cr>", "Income Statement (expenses)" },
    r = { "<cmd>!hledger register expenses --monthly --average --depth 1 not:acct:tax not:acct:family<cr>", "Register (expenses)" },
  },
}, { prefix = "<leader>h" })

-- }
