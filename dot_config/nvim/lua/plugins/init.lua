local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end
local trigger_text = ";"

return {
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"
      require("rainbow-delimiters.setup").setup {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
        blacklist = {
          "markdown",
          "help",
        },
      }
    end,
  },
  { "luckasRanarison/tree-sitter-hypr", ft = "hypr" },
  { "NvChad/nvterm",                    enabled = false },
  { "NvChad/nvim-colorizer.lua",        enabled = false },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    event = "VeryLazy",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    "aliaksandr-trush/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enable_cmp_source = false,
      enable_chat = false,
    },
    enabled = false,
    event = "BufEnter",
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
    },
    version = "1.*", -- use a release tag to download pre-built binaries
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
            elseif require("luasnip").locally_jumpable(1) then
              require("luasnip").jump(1)
            elseif has_words_before() then
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_prev()
            elseif require("luasnip").locally_jumpable(-1) then
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
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      -- add lazydev to your completion providers
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
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

        -- codeium = { name = "Codeium", module = "codeium.blink", score_offset = 100, async = true },
        -- codeium = {
        --   name = "codeium",
        --   module = "blink.compat.source",
        --   score_offset = 100,
        -- },
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          -- When linking markdown notes, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no LSP
          -- suggestions
          -- Disabling fallbacks as my snippets wouldn't show up
          -- Enabled fallbacks as this seems to be working now
          fallbacks = { "snippets", "buffer" },
          score_offset = 90, -- the higher the number, the higher the priority
        },
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
          max_items = 8,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 85, -- the higher the number, the higher the priority
          -- Only show snippets if I type the trigger_text characters, so
          -- to expand the "bash" snippet, if the trigger_text is ";" I have to
          -- type ";bash"
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            -- NOTE: remember that `trigger_text` is modified at the top of the file
            return before_cursor:match(trigger_text .. "%w*$") ~= nil
          end,
          -- After accepting the completion, delete the trigger_text characters
          -- from the final inserted text
          transform_items = function(_, items)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            if trigger_pos then
              for _, item in ipairs(items) do
                item.textEdit = {
                  newText = item.insertText or item.label,
                  range = {
                    start = { line = vim.fn.line "." - 1, character = trigger_pos - 1 },
                    ["end"] = { line = vim.fn.line "." - 1, character = col },
                  },
                }
              end
            end
            -- NOTE: After the transformation, I have to reload the luasnip source
            -- Otherwise really crazy shit happens and I spent way too much time
            -- figurig this out
            vim.schedule(function()
              require("blink.cmp").reload "snippets"
            end)
            return items
          end,
        },
      },

      snippets = {
        preset = "luasnip",
        -- This comes from the luasnip extra, if you don't add it, won't be able to
        -- jump forward or backward in luasnip snippets
        -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },

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
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    opts_extend = { "sources.default" },
  },
  {
    "danielfalk/smart-open.nvim",
    config = function()
      require("telescope").load_extension "smart_open"
    end,
    dependencies = { "kkharji/sqlite.lua" },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end,
    lazy = false,
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end,
    lazy = false,
  },
  {
    "vim-scripts/ReplaceWithRegister",
    lazy = false,
    config = function() end,
  },
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    enabled = false,
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          suggestion = {
            enable = false,
          },
          panel = {
            enable = false,
          },
        }
      end, 100)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        config = function()
          require("dap-go").setup()
          local dap = require "dap"
          dap.configurations.go = {}

          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "scanner debug",
            buildFlags = "-tags okr,osusergo,netgo,sqlite_omit_load_extension,sqlite",
            env = { SCANNER_SCANNER_URL = "0.0.0.0:3000" },
            program = vim.fn.getenv "GOPATH" .. "/scanner/cmd/scanner-server/",
            args = { "--config", vim.fn.getenv "GOPATH" .. "/scanner/configs/scanner/localhost/config.yml" },
            outputMode = "remote",
          })

          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "pipeline debug",
            buildFlags = "-tags fts5,json1",
            program = vim.fn.getenv "GOPATH" .. "/pipeline/cmd/",
            outputMode = "remote",
          })

          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "debug package",
            program = "${fileDirname}",
            outputMode = "remote",
          })

          table.insert(dap.configurations.go, {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
            outputMode = "remote",
          })
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup {
            render = {
              max_type_length = nil,
              max_value_line = nil,
            },
            expand_lines = true,
            layouts = {
              {
                elements = {
                  -- Elements can be strings or table with id and size keys.
                  { id = "scopes", size = 0.25 },
                  "breakpoints",
                  "watches",
                },
                size = 40, -- 40 columns
                position = "left",
              },
              {
                elements = {
                  "repl",
                },
                size = 0.25, -- 25% of total lines
                position = "bottom",
              },
            },
            controls = {
              -- dependencies Neovim nightly (or 0.8 when released)
              enabled = true,
              -- Display controls in this element
              element = "repl",
            },
          }
          local dap, dapui = require "dap", require "dapui"
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open {}
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close {}
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close {}
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup {
            virt_text_pos = "eol",
          }
        end,
      },
      {
        "nvim-telescope/telescope-dap.nvim",
        config = function()
          require("telescope").load_extension "dap"
        end,
      },
    },
    cmd = { "DapContinue", "DapToggleBreakpoint" },
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup {
        view = {
          merge_tool = {
            layout = "diff1_plain",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          },
        },
      }
    end,
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewLog" },
  },

  { "wgwoods/vim-systemd-syntax", ft = { "systemd" } },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
      "Gvimgrep",
      "Gstatus",
      "Gwrite",
      "Gw",
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:/]]

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        preview = {},
      }
    end,
  },
  { "tpope/vim-git",              lazy = false },
  {
    "akinsho/git-conflict.nvim",
    lazy = false,
    version = "*",
    config = function()
      require("git-conflict").setup {
        default_mappings = true,
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = {              -- They must have background color, otherwise the default color will be used
          incoming = "DiffText",
          current = "DiffAdd",
        },
      }
    end,
  },
  {
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup()
    end,
    lazy = false,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio",
      -- Your other test adapters here
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        -- your neotest config here
        adapters = {
          require "neotest-go" {
            experimental = { test_table = true },
            args = { "-count=1", "-timeout=60s" },
          },
        },
      }
    end,
  },
  {
    "Wansmer/symbol-usage.nvim",
    enabled = false,
    event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require("symbol-usage").setup {
        implementations = { disable = true },
      }
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = false },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "postgresql" }, lazy = false },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened

    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"), -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize" },    -- sessionoptions used for saving
        pre_save = nil,                                              -- a function to call before saving the session
        save_empty = false,                                          -- don't save if there are no open file buffers
      }
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>fd",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>eS",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>fq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },

    config = function()
      require("trouble").setup {}
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {}
    end,
  },
  {
    "shellRaining/hlchunk.nvim",

    event = { "BufReadPre", "BufNewFile" },

    config = function()
      require("hlchunk").setup {
        chunk = {
          enable = true,
          duration = 50,
          delay = 50,
        },
        indent = {
          enable = true,
        },
      }
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
      local builtin = require "statuscol.builtin"
      local segments = {
        {
          sign = {
            name = { "[DapBreakpoint|Marks*]" },
            maxwidth = 1,
          },
          click = "v:lua.ScSa",
        },
        {
          sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
          click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      }

      -- Check if the current directory is a git repo, if it is show the gitsigns in the gutter
      local current_rev = vim.fn.system "git rev-parse --show-toplevel 2> /dev/null"
      if current_rev ~= "" then
        table.insert(segments, {
          sign = {
            namespace = { "gitsign" },
            maxwidth = 1,
          },
          click = "v:lua.ScSa",
        })
      end

      table.insert(segments, {
        sign = {
          name = { ".*" },
          maxwidth = 1,
          colwidth = 1,
          wrap = true,
          auto = true,
        },
        click = "v:lua.ScSa",
      })

      local setup_table = {
        relculright = true,
        segments = segments,
      }
      require("statuscol").setup(setup_table)
    end,
  },
  {
    "chentoast/marks.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("marks").setup {}
    end,
  },
  { "mfussenegger/nvim-jdtls" },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "dbui", "diffview*", "diffview" },
    },
  },
}
