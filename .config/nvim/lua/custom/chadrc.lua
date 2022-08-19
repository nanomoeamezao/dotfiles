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

    -- ["folke/which-key.nvim"] = plugin_conf.whichkey,
    ["windwp/nvim-autopairs"] = {
      check_ts = true,
    },

    -- ["lukas-reineke/indent-blankline.nvim"] = function()
    --   vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
    --   vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
    --   vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
    --   vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
    --   vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
    --   vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
    --   vim.opt.listchars:append "space:⋅"
    --   vim.opt.listchars:append "eol:↴"
    --   return {
    --     space_char_blankline = " ",
    --     char_highlight_list = {
    --       "IndentBlanklineIndent1",
    --       "IndentBlanklineIndent2",
    --       "IndentBlanklineIndent3",
    --       "IndentBlanklineIndent4",
    --       "IndentBlanklineIndent5",
    --       "IndentBlanklineIndent6",
    --     },
    --   }
    -- end,

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
  -- hl_override = {
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
  -- },
}

return M
