-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- Language utilities {
lvim.builtin.treesitter.auto_install = false
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "lua",
  "json",
  "rust",
  "yaml",
  "ocaml",
  "haskell",
  "c",
  "ledger",
}
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers,
  {
    "ocamllsp",
    "rust-analyzer",
  })
lvim.format_on_save.enabled = true

vim.filetype.add({
  extension = {
    iml = "ocaml",
  },
})


-- override ocamlformat for iml files
vim.api.nvim_create_autocmd({
  "BufReadPre",
  "BufRead",
  "BufEnter",
  "BufNewFile",
  "BufNew",
}, {
  pattern = { "*.iml" },
  callback = function()
    -- options
    vim.opt.foldmethod = "indent"

    -- ocamllsp extra arg
    local null_ls = require("null-ls")
    local sources = {
      null_ls.builtins.formatting.ocamlformat.with({
        extra_args = { "--impl" },
      })
    }
    null_ls.setup({ sources = sources })
  end,
})

-- }

-- Key bindings {

--typos for save and quit {

---Add an alias to a 0-argument command
---@param alias string
---@param cmd function
local add_alias_to_cmd = function(alias, cmd)
  vim.api.nvim_create_user_command(alias,
    function(_)
      cmd()
    end,
    { nargs = 0 })
end
add_alias_to_cmd("WQ", vim.cmd.wq)
add_alias_to_cmd("Wq", vim.cmd.wq)
add_alias_to_cmd("W", vim.cmd.w)
add_alias_to_cmd("Q", vim.cmd.q)
add_alias_to_cmd("X", vim.cmd.x)
add_alias_to_cmd("Xa", vim.cmd.xa)
-- }

-- which_key {
lvim.builtin.which_key.mappings["j"] = {
  name = "Hop",
  f = { "<cmd>HopChar1<cr>", "HopChar1" },
  j = { "<cmd>HopVertical<cr>", "HopVertical" },
  k = { "<cmd>HopVertical<cr>", "HopVertical" },
  w = { "<cmd>HopWord<cr>", "HopWord" },
}

lvim.builtin.which_key.mappings.b.d = {
  "<cmd>bdelete<cr>", "Close Buffer",
}

lvim.builtin.which_key.mappings["h"] = {}

lvim.builtin.which_key.mappings.h.h = {
  "<cmd>noh<cr>", "No highlight",
}

lvim.builtin.which_key.mappings.h.l = {
  "<cmd>edit /Users/yuxi/.hledger.journal<cr>",
  "Edit hledger journal",
}
-- }

-- }

-- Appearance {
lvim.colorscheme = "monokai_pro"
-- }

-- Additional plugins
lvim.plugins = {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  "tpope/vim-unimpaired",
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },

    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      -- you also will likely want nvim-cmp or some completion engine
    },
    opts = {
      mappings = true,
      lsp = {
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        on_exit = require("lvim.lsp").common_on_exit,
        capabilities = require("lvim.lsp").common_capabilities(),
      },
    },
  },
  {
    "tanvirtin/monokai.nvim",
    config = function() require("monokai").setup {} end
  },
  {
    "simrat39/rust-tools.nvim",
    -- ft = { "rust", "rs" },
  },
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require "hop".setup()
    end
  },
  {
    "ledger/vim-ledger",
    ft = { "ledger" },
  },
  {
    "johmsalas/text-case.nvim",
    keys = "ga",
    config = function()
      require("textcase").setup {}
    end
  },
}

-- nvim options {
vim.opt.wrap = true
vim.opt.wildmenu = true -- visual autocomplete for command menu
vim.opt.wildmode = "longest:full,full"
vim.opt.textwidth = 80

-- do not wrap in insert mode
vim.api.nvim_create_autocmd({
  "BufReadPre",
  "BufEnter",
  "BufNewFile",
  "BufNew",
}, {
  pattern = { "*" },
  command = "setlocal formatoptions-=t",
})
-- folding {
-- use treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- do not fold by default
vim.opt.foldenable = false
-- }

-- }
