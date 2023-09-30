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
  "c"
}
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers,
  {
    "ocamllsp",
    "rust-analyzer",
  })
lvim.format_on_save.enabled = true
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
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },

    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      -- you also will likely want nvim-cmp or some completion engine
    },
    opts = { mappings = true }
  },
  {
    "tanvirtin/monokai.nvim",
    config = function() require("monokai").setup {} end
  },
  {
    "simrat39/rust-tools.nvim",
    -- ft = { "rust", "rs" },
  },
}

-- nvim options {
vim.o.wrap = true
-- }
