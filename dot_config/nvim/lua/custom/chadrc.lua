local M = {}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
M.ui = {
  theme = "catppuccin",
  hl_override = {
    IndentBlanklineContextChar = { fg = "purple" },
  },
  statusline = {
    overriden_modules = function()
      return {
        LSP_progress = function()
          return ""
        end,
      }
    end,
  },
}
return M
