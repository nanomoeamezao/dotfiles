local trigger_text = ";"
return {
  signature = { enabled = true },
  -- 'default' for mappings similar to built-in completion
  -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
  -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
  -- See the full "keymap" documentation for information on defining your own keymap.
  keymap = {
    preset = "default",
    ["<Tab>"] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_next()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      "fallback",
    },
    ["<S-Tab>"] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_prev()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        end
      end,
      "fallback",
    },
    ["<CR>"] = { "select_and_accept", "fallback" },
    ["<C-k>"] = { "show_documentation" },
  },

  appearance = {
    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    -- add lazydev to your completion providers
    default = { "codeium", "lazydev", "lsp", "path", "snippets", "buffer" },
    per_filetype = {
      sql = { "snippets", "dadbod" },
      mysql = { "snippets", "dadbod" },
      postgresql = { "snippets", "dadbod" },
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },

      codeium = { name = "Codeium", module = "codeium.blink", score_offset = 100, async = true },
      path = {
        name = "path",
        module = "blink.cmp.sources.path",
        score_offset = 25,
        -- When typing a path, I would get snippets and text in the
        -- suggestions, I want those to show only if there are no path
        -- suggestions
        fallbacks = { "snippets", "buffer" },
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = function(context)
            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
          end,
          show_hidden_files_by_default = true,
        },
      },
      buffer = {
        name = "Buffer",
        enabled = true,
        max_items = 3,
        module = "blink.cmp.sources.buffer",
        min_keyword_length = 4,
        score_offset = 15, -- the higher the number, the higher the priority
      },
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      snippets = {
        name = "snippets",
        enabled = true,
        max_items = 4,
        min_keyword_length = 2,
        module = "blink.cmp.sources.snippets",
        score_offset = 100, -- the higher the number, the higher the priority
      },
    },
  },
  snippets = { preset = "luasnip" },
  cmdline = {
    enabled = false,
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      if type == ":" then
        return { "cmdline" }
      end
      return {}
    end,
  },
  completion = {
    menu = require("nvchad.blink").menu,
    list = {
      selection = {
        preselect = true,
      },
    },
    accept = { auto_brackets = { enabled = true } },
    ghost_text = { enabled = true },
    documentation = {
      auto_show = true,
      window = {
        border = "rounded",
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
}
