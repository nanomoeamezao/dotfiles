return {
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
  ["windwp/nvim-ts-autotag"] = {
    ft = { "html", "javascriptreact" },
    after = "nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  ["ggandor/leap.nvim"] = {
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  ["vim-scripts/ReplaceWithRegister"] = {},
  ["github/copilot.vim"] = {
    disable = true,
  },
  ["zbirenbaum/copilot.lua"] = {
    after = "nvim-lspconfig",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          cmp = {
            enabled = true,
            method = "getCompletionsCycling",
          },
        }
      end, 100)
    end,
    -- disable = true,
  },
  ["zbirenbaum/copilot-cmp"] = {},
  ["mfussenegger/nvim-dap"] = {
    cmd = { "DapContinue", "DapToggleBreakpoint" },
  },
  ["xuxinx/nvim-dap-go"] = {
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
        program = "/home/neo/code/scanner/vuln-service/cmd/vuln-service/",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        request = "launch",
        name = "scanner debug",
        program = "/home/neo/code/scanner/cmd/scanner-server/",
      })
      table.insert(dap.configurations.go, {
        type = "go",
        request = "launch",
        name = "netscan debug",
        program = "/home/neo/code/scanner/netscan-service/cmd/netscan-service/",
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
  },
  ["https://git.sr.ht/~whynothugo/lsp_lines.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = true,
      }
    end,
    disable = true,
  },
  ["folke/trouble.nvim"] = {
    after = "nvim-lspconfig",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  },
  ["TimUntersberger/neogit"] = {
    cmd = "Neogit",
    config = function()
      require("neogit").setup()
    end,
  },
  ["rmagatti/auto-session"] = {
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
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
    disable = true,
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
        enable_fold_end_virt_text = true,
        close_fold_kinds = {},
        preview = {},
      }
    end,
  },
  ["tpope/vim-git"] = {},
  ["nvim-neotest/neotest"] = {
    after = "nvim-treesitter",
    ft = { "go" },
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-go" {
            experimental = {
              test_table = true,
            },
          },
        },
      }
    end,
  },
  ["folke/lua-dev.nvim"] = {
    ft = { "lua" },
    config = function()
      require("lua-dev").setup {}
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
      require("hlargs").setup {
        color = "#ef9062",
        hl_priority = 90000,
        highlight = { "IncSearch" },
      }
    end,
    disable = true,
  },
  ["rcarriga/nvim-notify"] = {},
  ["nanotee/sqls.nvim"] = {
    ft = { "sql" },
  },
}
