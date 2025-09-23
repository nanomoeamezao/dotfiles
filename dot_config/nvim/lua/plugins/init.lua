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
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    event = "VeryLazy",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    "Exafunction/windsurf.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = true,
    config = function()
      require("codeium").setup {
        enable_cmp_source = false,
        enable_chat = false,
      }
    end,
    event = "BufEnter",
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdLineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
      },
    },
    version = "1.*", -- use a release tag to download pre-built binaries
    opts_extend = { "sources.default" },
    opts = function()
      return require "configs.blink"
    end,
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
            buildFlags = "-tags se,sqlite,production,okr,osusergo,netgo,sqlite_omit_load_extension,sqlite",
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
          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "exporter debug",
            program = vim.fn.getenv "GOPATH" .. "/scanner-parser/",
            args = {
              "--db1",
              vim.fn.getenv "GOPATH" .. "/scanner/scanner.db",
              "--db2",
              vim.fn.getenv "GOPATH" .. "/scanner/vuln.db",
              "--sql1file",
              vim.fn.getenv "GOPATH" .. "/scanner-parser/query1.sql",
              "--sql2file",
              vim.fn.getenv "GOPATH" .. "/scanner-parser/query2.sql",
              "--db2cols",
              "identifier, description",
            },
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
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          merge_tool = {
            layout = "diff1_plain",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          },
        },
      }
      local function set_diff_highlights()
        local is_dark = vim.o.background == "dark"
        if is_dark then
          vim.api.nvim_set_hl(0, "DiffAdd", { fg = "none", bg = "#2e4b2e", bold = true })
          vim.api.nvim_set_hl(0, "DiffDelete", { fg = "none", bg = "#4c1e15", bold = true })
          vim.api.nvim_set_hl(0, "DiffChange", { fg = "none", bg = "#45565c", bold = true })
          vim.api.nvim_set_hl(0, "DiffText", { fg = "none", bg = "#996d74", bold = true })
        else
          vim.api.nvim_set_hl(0, "DiffAdd", { fg = "none", bg = "palegreen", bold = true })
          vim.api.nvim_set_hl(0, "DiffDelete", { fg = "none", bg = "tomato", bold = true })
          vim.api.nvim_set_hl(0, "DiffChange", { fg = "none", bg = "lightblue", bold = true })
          vim.api.nvim_set_hl(0, "DiffText", { fg = "none", bg = "lightpink", bold = true })
        end
      end
      set_diff_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("DiffColors", { clear = true }),
        callback = set_diff_highlights,
      })
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
    enabled = false,
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
      { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
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
        adapters = {
          require "neotest-golang" {
            go_test_args = { "--count=1", "--timeout=60s" },
          },
        },
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
    enabled = true,
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
          exclude_filetypes = {
            "*.dbout",
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require "configs.nvim-lint"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      multiline_threshold = 1, -- Maximum number of lines to show for a single context
    },
  },
  {
    "unblevable/quick-scope",
    event = "VeryLazy",
    opts = {},
    config = function()
      vim.cmd [[
          highlight QuickScopePrimary guifg='#af5fff' gui=nocombine
          highlight QuickScopeSecondary guifg='#5fffff' gui=nocombine
      ]]
    end,
  },
}
