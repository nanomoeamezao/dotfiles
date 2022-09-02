local M = {}

local plugin_conf = require "custom.plugins.configs"
local userPlugins = require "custom.plugins"

M.plugins = {
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
    ["windwp/nvim-autopairs"] = {
      check_ts = true,
    },

    ["williamboman/mason.nvim"] = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "shfmt",
        "shellcheck",
        "marksman",
      },
    },

    ["NvChad/ui"] = {
      statusline = {
        overriden_modules = function()
          return {
            LSP_progress = function()
              return ""
            end,
          }
        end,
      },
    },
  },
}

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
