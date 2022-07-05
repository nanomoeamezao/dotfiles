local M = {}

-- overriding default plugin configs!
M.treesitter = {
   ensure_installed = {
      "lua",
      "vim",
      "html",
      "css",
      "go",
      "javascript",
      "json",
      "toml",
      "markdown",
      "c",
      "bash",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   textobjects = {
      select = {
         enable = true,
         -- Automatically jump forward to textobj, similar to targets.vim
         lookahead = true,
         keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
         },
      },
   },
   rainbow = {
      enable = true,
      extended_mode = true,
   },
   autotag = {
      enable = true,
   },
}

M.whichkey = {
   operators = { gr = "replace with register" },
   triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      i = { "j", "k", "v" },
      v = { "j", "k", "v" },
      n = { "v", "<S-v>", "<A-v>" },
   },
}

M.cmp = function()
   local cmp = require "cmp"
   return {
      experimental = {
         ghost_text = true,
      },
      preselect = cmp.PreselectMode.None,
      sources = {
         { name = "copilot" },
         { name = "luasnip" },
         { name = "nvim_lsp" },
         { name = "buffer" },
         { name = "nvim_lua" },
         { name = "path" },
      },
      formatting = {
         format = function(entry, vim_item)
            local icons = require("ui.icons").lspkind
            if entry.source.name == "copilot" then
               vim_item.kind = "  Copilot"
               vim_item.kind_hl_group = "CmpItemKindCopilot"
               return vim_item
            end
            vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
            return vim_item
         end,
      },
      sorting = {
         priority_weight = 2,
         comparators = {
            cmp.config.compare.exact,
            require("copilot_cmp.comparators").prioritize,
            require("copilot_cmp.comparators").score,

            -- Below is the default comparitor list and order for nvim-cmp
            -- cmp.config.compare.offset,
            -- cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            -- cmp.config.compare.length,
            -- cmp.config.compare.order,
         },
      },
   }
end

return M
