return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "custom.configs.treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "mrjones2014/nvim-ts-rainbow",
    },
  },
  { "luckasRanarison/tree-sitter-hypr", ft = "hypr" },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        delete = { hl = "DiffDelete", text = "│", numhl = "GitSignsDeleteNr" },
      },
    },
  },
  { "williamboman/mason.nvim",          enabled = false },
  { "NvChad/nvterm",                    enabled = false },
  { "folke/which-key.nvim",             enabled = false },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "NvChad/ui",
    config = function()
      vim.opt.statusline = "%!v:lua.require('custom.configs.statusline').run()"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        enabled = false,
        config = function()
          require("copilot_cmp").setup {}
        end,
      },
    },
    opts = {
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      end,
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
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_current_context_start = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require("custom.configs.null-ls").setup()
        end,
      },
      { "folke/neodev.nvim" },
    },
    config = function()
      require("neodev").setup {}
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
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
  { "vim-scripts/ReplaceWithRegister", lazy = false },
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
            name = "updatemaker",
            buildFlags = "-tags osusergo,netgo,sqlite_omit_load_extension",
            program = vim.fn.getenv "GOPATH" .. "/scanner/cmd/update-maker/",
            args = {
              "/home/neozumm/Downloads/646192be228a2a06eb6ae7b79206e70e_v0.2.542.tar.gz",
              vim.fn.getenv "GOPATH" .. "/scanner/new.db",
            },
          })

          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "scanner debug",
            -- buildFlags = "-tags noauth",
            env = { SCANNER_SCANNER_URL = "0.0.0.0:3000" },
            program = vim.fn.getenv "GOPATH" .. "/scanner/cmd/scanner-server/",
            args = { "--config", vim.fn.getenv "GOPATH" .. "/scanner/configs/scanner/localhost/config.yml" },
          })
          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "netscan debug",
            program = vim.fn.getenv "GOPATH" .. "/scanner/cmd/netscan-service/",
          })
          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "installer debug",
            program = vim.fn.getenv "GOPATH" .. "/scanner-installer/cmd/installer/",
            args = { "install" },
          })
          table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            name = "datacoll debug",
            program = vim.fn.getenv "GOPATH" .. "/data-collector/cmd/data-collector/",
            args = {
              "-c",
              "configs/config.yaml",
              "-r",
              "configs/resources/nvd.yaml",
              "-r",
              "configs/resources/redhat.yaml",
              "-r",
              "configs/resources/debian.yaml",
              "-r",
              "configs/resources/ubuntu.yaml",
              "-r",
              "configs/resources/bdu.yaml",
              "-r",
              "configs/resources/arch.yaml",
              "-r",
              "configs/resources/exploitdb.yaml",
            },
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

  { "wgwoods/vim-systemd-syntax",      ft = { "systemd" } },
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
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- vim.o.foldcolumn = "1"
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
  { "tpope/vim-git", lazy = false },
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go" },
    config = function()
      require("go").setup {
        disable_defaults = true,
      }
    end,
  },
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
    "akinsho/bufferline.nvim",
    version = "*",
    enabled = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("bufferline").setup {
        options = {
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match "error" and " " or " "
            return " " .. icon .. count
          end,
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
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTRun" },
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
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
}
