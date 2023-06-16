local M = {}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
M.ui = {
  theme = "bearded-arc",
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
