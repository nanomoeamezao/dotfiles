local M = {}

-- overriding default plugin configs!
M.treesitter = {
  ensure_installed = {
    "lua",
    "vim",
    "html",
    "css",
    "go",
    "gomod",
    "javascript",
    "json",
    "toml",
    "markdown",
    "c",
    "bash",
    "regex",
    "gitignore",
    "dockerfile",
    "comment",
    "yaml",
    "sql",
    "norg",
  },
  highlight = {
    enable = true,
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
  indent = {
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
  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
  end
  local cmp = require "cmp"
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
  return {
    experimental = {
      ghost_text = true,
    },
    preselect = cmp.PreselectMode.None,
    sources = {
      { name = "copilot", group_index = 2 },
      { name = "nvim_lsp", group_index = 2 },
      { name = "nvim_lua", group_index = 2 },
      { name = "luasnip", group_index = 2 },
      { name = "buffer", group_index = 2 },
      { name = "path", group_index = 2 },
    },
    mappings = {
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      ["<Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end),
    },
    formatting = {
      format = function(entry, vim_item)
        local icons = require("nvchad_ui.icons").lspkind
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

        require("copilot_cmp.comparators").prioritize,
        require("copilot_cmp.comparators").score,
        cmp.config.compare.exact,

        -- Below is the default comparitor list and order for nvim-cmp
        -- cmp.config.compare.offset,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }
end

return M
