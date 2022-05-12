local M = {}

local map = nvchad.map
local plugin_conf = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"
M.plugins = {
   status = {
      colorizer = true,
   },
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },

   user = userPlugins,
   override = {
      ["nvim-treesitter/nvim-treesitter"] = plugin_conf.treesitter,
   },
}

M.mappings = {}

M.ui = {
   theme = "chadracula",
   hl_override = {
      DiffText = {
         bg = "#FF5555",
      },
   },
}

M.options = {}

return M
