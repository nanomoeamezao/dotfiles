local M = {}

local plugin_conf = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"
local cmp = require "cmp"

M.plugins = {
   -- status = {
   --    colorizer = true,
   -- },
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },

   user = userPlugins,
   override = {
      ["nvim-treesitter/nvim-treesitter"] = plugin_conf.treesitter,
      ["hrsh7th/nvim-cmp"] = {
         preselect = cmp.PreselectMode.None,
         sources = {
            { name = "copilot" },
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
         },
      },
      ["nvim-telescope/telescope.nvim"] = {
         extensions = {
            fzf = {
               fuzzy = true,
               override_generic_sorter = true, -- override the generic sorter
               override_file_sorter = true, -- override the file sorter
            },
         },
      },
      ["folke/which-key.nvim"] = plugin_conf.whichkey,
   },
}

M.mappings = require "custom.mappings"

M.ui = {
   theme = "onenord",
   -- hl_override = {
   --    DiffText = {
   --       bg = "#FF5555",
   --    },
   -- },
}

M.options = {
   user = function()
      vim.opt.tabstop = 4
      vim.opt.timeoutlen = 400
   end,
}

return M
