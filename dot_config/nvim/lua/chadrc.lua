---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "monochrome",
  hl_override = {
    IblScopeChar = { fg = "purple" },
  },
  tabufline = {
    enabled = false,
    lazyload = false,
  },
}

M.lsp = {
  semantics = true,
}

return M
