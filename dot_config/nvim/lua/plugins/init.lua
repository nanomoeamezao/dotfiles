return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
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
  { "luckasRanarison/tree-sitter-hypr",    ft = "hypr" },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        delete = { text = "│" },
      },
      on_attach = function() end,
    },
  },
  { "williamboman/mason.nvim",             enabled = false },
  { "NvChad/nvterm",                       enabled = false },
  { "folke/which-key.nvim",                enabled = false },
  { "NvChad/nvim-colorizer.lua",           enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "hrsh7th/nvim-cmp",
    -- dependencies = {
    --   -- {
    --   --   "zbirenbaum/copilot-cmp",
    --   --   enabled = false,
    --   --   config = function()
    --   --     require("copilot_cmp").setup {}
    --   --   end,
    --   -- },
    -- },
    opts = {
      preselect = require("cmp").PreselectMode.None,
      sources = {
        { name = "copilot",  max_item_count = 3 },
        { name = "codeium",  max_item_count = 3 },
        { name = "nvim_lsp", max_item_count = 30 },
        { name = "luasnip" },
        { name = "buffer",   max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "path" },
      },
      priority_weight = 2,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions_list = { "fzf" },
      extensions = {
        smart_open = {
          show_scores = false,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
          match_algorithm = "fzf",
          disable_devicons = false,
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
        },
      },
      pickers = {
        lsp_references = { show_line = false },
        buffers = {
          mappings = {
            n = {
              ["<c-x>"] = require("telescope.actions").delete_buffer,
            },
          },
        },
      },
    },
    dependencies = {
      {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension "ui-select"
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          require("telescope").load_extension "live_grep_args"
        end,
      },
      {
        "benfowler/telescope-luasnip.nvim",
        config = function()
          require("telescope").load_extension "luasnip"
        end,
      },
    },
  },
  {
    "danielfalk/smart-open.nvim",
    config = function()
      require("telescope").load_extension "smart_open"
    end,
    dependencies = { "kkharji/sqlite.lua" },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require("configs.null-ls").setup()
        end,
      },
      { "folke/neodev.nvim" },
    },
    config = function()
      require("neodev").setup {}
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
      vim.cmd [[
      hi @lsp.type.parameter  guifg=Orange
      ]]
    end,
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
            buildFlags = "-tags okr,osusergo,netgo,sqlite_omit_load_extension",
            env = { SCANNER_SCANNER_URL = "0.0.0.0:3000" },
            program = vim.fn.getenv "GOPATH" .. "/scanner/cmd/scanner-server/",
            args = { "--config", vim.fn.getenv "GOPATH" .. "/scanner/configs/scanner/okr/config.yml" },
          })

          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "debug package",
            program = "${fileDirname}",
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
    "Exafunction/codeium.nvim",
    event = "VeryLazy",
    config = function()
      require("codeium").setup {}
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "plsql" }, lazy = true },
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "plsql" },
        callback = function()
          require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
        end,
      })
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
}
