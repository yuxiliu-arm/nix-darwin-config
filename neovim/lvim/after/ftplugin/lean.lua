-- https://github.com/Julian/dotfiles/blob/54d8856daa893b8574b712140607ea624e64d558/.config/nvim/after/ftplugin/lean.lua
local lean = require("lean")

-- Match mathlib's default style.
vim.bo.textwidth = 100

-- vim.opt_local.signcolumn = "yes"

vim.g.maplocalleader = "  "

function _G.lean_live_grep()
  require "telescope.builtin".live_grep {
    path_display = { "tail" },
    search_dirs = lean.current_search_paths()
  }
end

vim.api.nvim_buf_set_keymap(
  0, "n", "<LocalLeader>g", "<Cmd>lua lean_live_grep()<CR>", { noremap = true }
)

vim.cmd [[
  highlight link leanTactic Green
]]
