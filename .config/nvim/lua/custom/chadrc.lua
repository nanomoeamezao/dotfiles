local M = {}

local plugin_conf = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"

M.plugins = {
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },

   user = userPlugins,
   override = {
      ["nvim-treesitter/nvim-treesitter"] = plugin_conf.treesitter,
      ["hrsh7th/nvim-cmp"] = plugin_conf.cmp,
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
      ["windwp/nvim-autopairs"] = {
         check_ts = true,
      },
   },
}

M.mappings = require "custom.mappings"

M.ui = {
   theme = "nightfox",
   hl_override = {
      LspReferenceWrite = {
         underline = true,
         bg = "black",
         fg = "green",
      },
      LspReferenceRead = {
         underline = true,
         bg = "black",
         fg = "green",
      },
      LspReferenceText = {
         underline = true,
         bg = "black",
         fg = "green",
      },
   },
}

M.options = {
   user = function()
      vim.opt.tabstop = 4
      vim.opt.timeoutlen = 400
      vim.g.neovide_cursor_animation_length = 0
      vim.g.neovide_cursor_trail_length = 0

      vim.opt.relativenumber = true
      vim.opt.swapfile = false
      vim.opt.laststatus = 3
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
         ["*"] = false,
         ["javascript"] = true,
         ["typescript"] = true,
         ["lua"] = false,
         ["rust"] = true,
         ["c"] = true,
         ["c#"] = true,
         ["c++"] = true,
         ["go"] = true,
         ["python"] = true,
         ["sql"] = false,
      }

      vim.cmd [[
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
]]
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
   end,
}

return M
