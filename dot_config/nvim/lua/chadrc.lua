-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "monochrome",
  hl_override = {
    IblScopeChar = { fg = "purple" },
  },
}

M.ui = {
  tabufline = {
    enabled = false,
    lazyload = false,
  },
  statusline = {
    theme = "default",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "nvimlint", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      nvimlint = function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "󰦕"
        end
        return "󱉶 " .. table.concat(linters, ", ")
      end,
    },
  },
}

M.lsp = {
  semantics = true,
}

return M
