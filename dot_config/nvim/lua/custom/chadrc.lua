local M = {}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
M.ui = {
  theme = "catppuccin",
  hl_override = {
    IndentBlanklineContextChar = { fg = "purple" },
  },
  tabufline = {
    enabled = false,
    lazyload = false,
  },
}
return M
