local M = {}

local userPlugins = require "custom.plugins"

M.plugins = userPlugins

M.mappings = require "custom.mappings"

M.ui = {
  theme = "nightfox",
  hl_override = {
    IndentBlanklineContextChar = { fg = "purple" },
    -- IndentBlanklineContextStart = { bg = "purple" },
    --   LspReferenceWrite = {
    --     underline = true,
    --     bg = "black",
    --     fg = "green",
    --   },
    --   LspReferenceRead = {
    --     underline = true,
    --     bg = "black",
    --     fg = "green",
    --   },
    --   LspReferenceText = {
    --     underline = true,
    --     bg = "black",
    --     fg = "green",
    --   },
  },
}

return M
