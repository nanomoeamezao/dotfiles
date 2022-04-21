local M = {}

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

   install = userPlugins,
   default_plugin_config_replace = {
      nvim_treesitter = plugin_conf.treesitter,
   },
}

M.mappings = {
   plugins = {
      lspconfig = {
         references = "gR",
         -- code_action = "",
      },
   },
}

M.ui = {
   theme = "onedark",
}

return M
