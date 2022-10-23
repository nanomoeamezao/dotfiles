local plugin_conf = require "custom.plugins.configs"
return {
  -- OVERRIDES
  ["nvim-treesitter/nvim-treesitter"] = { override_options = plugin_conf.treesitter },

  ["hrsh7th/nvim-cmp"] = { override_options = plugin_conf.cmp },

  ["nvim-telescope/telescope.nvim"] = {
    override_options = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
        },
      },
    },
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require "plugins.configs.telescope"
    end,
    setup = function()
      require("core.utils").load_mappings "telescope"
    end,
  },
  ["windwp/nvim-autopairs"] = { override_options = { check_ts = true } },
  ["NvChad/ui"] = {
    override_options = {
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
  ["lukas-reineke/indent-blankline.nvim"] = {
    override_options = {
      show_current_context_start = false,
    },
  },

  -- CUSTOM PLUGINS
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.null-ls").setup()
    end,
  },
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    after = "telescope.nvim",
    run = "make",
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },
  ["ur4ltz/surround.nvim"] = {
    config = function()
      require("surround").setup { mappings_style = "surround" }
    end,
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter",
  },
  ["p00f/nvim-ts-rainbow"] = {
    after = "nvim-treesitter",
  },
  ["ggandor/leap.nvim"] = {
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  ["vim-scripts/ReplaceWithRegister"] = {},
  ["zbirenbaum/copilot.lua"] = {
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {}
      end, 100)
    end,
  },
  ["zbirenbaum/copilot-cmp"] = {
    after = "copilot.lua",
    config = function()
      require("copilot_cmp").setup {}
    end,
  },
  ["mfussenegger/nvim-dap"] = {
    cmd = { "DapContinue", "DapToggleBreakpoint" },
  },
  ["leoluz/nvim-dap-go"] = {
    after = "nvim-dap",
    config = function()
      require("dap-go").setup()
      local dap = require "dap"
      dap.configurations.go = {}

      table.insert(dap.configurations.go, {
        type = "go",
        request = "launch",
        name = "vuln debug",
        showLog = true,
        program = vim.fn.getenv "GOPATH" .. "/scanner/vuln-service/cmd/vuln-service/",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        request = "launch",
        name = "scanner debug",
        program = vim.fn.getenv "GOPATH" .. "/scanner/cmd/scanner-server/",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        request = "launch",
        name = "netscan debug",
        program = vim.fn.getenv "GOPATH" .. "/scanner/netscan-service/cmd/netscan-service/",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        request = "launch",
        name = "debug package",
        program = "${fileDirname}",
      })
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    after = "nvim-dap",
    config = function()
      require("dapui").setup {
        render = {
          max_type_length = 1000,
        },
        expand_lines = vim.fn.has "nvim-0.7",
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
          -- Requires Neovim nightly (or 0.8 when released)
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
  ["theHamsta/nvim-dap-virtual-text"] = {
    after = "nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup {}
    end,
  },
  ["nvim-telescope/telescope-dap.nvim"] = {
    after = { "nvim-dap", "telescope.nvim" },
    config = function()
      require("telescope").load_extension "dap"
    end,
  },
  ["sindrets/diffview.nvim"] = {
    config = function()
      require("diffview").setup {}
    end,
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewLog" },
  },
  ["folke/todo-comments.nvim"] = {
    config = function()
      require("todo-comments").setup()
    end,
  },
  ["benfowler/telescope-luasnip.nvim"] = {
    after = { "telescope.nvim" },
    config = function()
      require("telescope").load_extension "luasnip"
    end,
    module = "telescope._extensions.luasnip", -- if you wish to lazy-load
  },
  ["wgwoods/vim-systemd-syntax"] = { ft = { "systemd" } },
  ["tpope/vim-fugitive"] = {
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
    config = function()
      local cmp = require "cmp"
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources {
          { name = "cmp_git" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
  ["folke/trouble.nvim"] = {
    after = "nvim-lspconfig",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  },
  ["nvim-treesitter/nvim-treesitter-context"] = {
    after = "nvim-treesitter",
    config = function()
      require("treesitter-context").setup {
        enable = true,
      }
    end,
  },
  ["bennypowers/nvim-regexplainer"] = {
    after = "nvim-treesitter",
    disable = true,
    requires = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("regexplainer").setup {
        filetypes = {
          "html",
          "js",
          "cjs",
          "mjs",
          "ts",
          "jsx",
          "tsx",
          "cjsx",
          "mjsx",
          "go",
          "sh",
        },
        mappings = {},
      }
    end,
  },
  ["j-hui/fidget.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("fidget").setup()
    end,
  },
  ["kevinhwang91/nvim-ufo"] = {
    requires = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        preview = {},
      }
    end,
  },
  ["tpope/vim-git"] = {},
  ["nvim-neotest/neotest"] = {
    module = "neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
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
          require "neotest-go" {
            experimental = {
              test_table = true,
            },
            -- args = { "-count=1", "-timeout=60s" },
            args = { "-timeout=60s" },
          },
        },
      }
    end,
  },
  ["ray-x/go.nvim"] = {
    ft = { "go" },
    config = function()
      require("go").setup {
        disable_defaults = true,
      }
    end,
  },
  ["nvim-telescope/telescope-ui-select.nvim"] = {
    after = { "telescope.nvim", "go.nvim" },
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  ["monkoose/matchparen.nvim"] = {
    config = function()
      require("matchparen").setup()
    end,
  },
  ["m-demare/hlargs.nvim"] = {
    after = { "nvim-treesitter" },
    config = function()
      require("hlargs").setup {}
    end,
  },
  ["rcarriga/nvim-notify"] = {},
  ["nanotee/sqls.nvim"] = {
    ft = { "sql" },
  },
  ["akinsho/git-conflict.nvim"] = {
    tag = "*",
    config = function()
      require("git-conflict").setup {
        default_mappings = true,
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = "DiffText",
          current = "DiffAdd",
        },
      }
    end,
  },
  ["nvim-neorg/neorg"] = {
    ft = "norg",
    cmd = { "Neorg", "Telescome neorg" },
    run = ":Neorg sync-parsers", -- This is the important bit!
    requires = "nvim-neorg/neorg-telescope",
    config = function()
      local cmp = require "cmp"
      cmp.setup.filetype("norg", {
        sources = cmp.config.sources {
          { name = "neorg" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
      })
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.ui"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.integrations.telescope"] = {},
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
              },
            },
          },
        },
      }
    end,
  },
  ["miversen33/netman.nvim"] = {
    disable = true,
    branch = "issue-28-libuv-shenanigans",
    config = function()
      require "netman"
    end,
  },

  ["stevearc/aerial.nvim"] = {
    module = "aerial",
    config = function()
      require("aerial").setup()
    end,
  },
}
