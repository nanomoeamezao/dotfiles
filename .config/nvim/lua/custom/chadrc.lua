local M = {}

local map = require("core.utils").map
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
   theme = "onedark",
}

M.options = {
   tabstop = 4,
   nvChad = {
      insert_nav = false,
   },
}

return M
