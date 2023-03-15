return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "custom.configs.treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "mrjones2014/nvim-ts-rainbow",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        delete = { hl = "DiffDelete", text = "│", numhl = "GitSignsDeleteNr" },
      },
    },
  },
  { "williamboman/mason.nvim", enabled = false },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      -- extensions = {
      --   -- fzf = {
      --   --   fuzzy = true,
      --   --   override_generic_sorter = true, -- override the generic sorter
      --   --   override_file_sorter = true, -- override the file sorter
      --   -- },
      -- },
      pickers = {
        lsp_references = { show_line = false },
      },
    },
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "live_grep_args"
    end,
  },
  { "windwp/nvim-autopairs", opts = { check_ts = true } },
  { "lukas-reineke/indent-blankline.nvim", opts = {
    show_current_context_start = false,
  } },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require("custom.configs.null-ls").setup()
        end,
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup()
        end,
      },
      {
        "utilyre/barbecue.nvim",
        version = "*",
        name = "barbecue",
        dependencies = {
          "SmiteshP/nvim-navic",
        },
        opts = {
          exclude_filetypes = { "gitcommit", "toggleterm", "chatgpt" },
        },
      },
      { "folke/neodev.nvim" },
    },
    config = function()
      require("neodev").setup()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
      vim.cmd [[
      hi @lsp.type.parameter  guifg=Orange
      ]]
    end,
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    config = function()
      require("telescope").load_extension "fzy_native"
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
    enabled = false,
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {}
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    config = function()
      require("copilot_cmp").setup {}
    end,
  },
  { "mfussenegger/nvim-dap", cmd = { "DapContinue", "DapToggleBreakpoint" } },
  {
    "leoluz/nvim-dap-go",
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
      require("nvim-dap-virtual-text").setup {}
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    config = function()
      require("telescope").load_extension "dap"
    end,
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
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "benfowler/telescope-luasnip.nvim",
    config = function()
      require("telescope").load_extension "luasnip"
    end,
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
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,diff:/]]

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
    "nvim-neotest/neotest",
    dependencies = {
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
          },
        },
      }
    end,
  },
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
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "monkoose/matchparen.nvim",
    lazy = false,
    config = function()
      require("matchparen").setup()
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
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = "DiffText",
          current = "DiffAdd",
        },
      }
    end,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = { "Neorg" },
    build = ":Neorg sync-parsers", -- This is the important bit!
    dependencies = "nvim-neorg/neorg-telescope",
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
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    config = function()
      require("aerial").setup()
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
    "kevinhwang91/nvim-hlslens",
    lazy = false,
    config = function()
      require("hlslens").setup {}
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    config = function()
      require("scrollbar").setup {}
      require("scrollbar.handlers.search").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    enabled = false,
    config = function()
      require("lsp-inlayhints").setup {
        inlay_hints = {
          highlight = "Comment",
        },
      }
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
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
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      vim.o.foldcolumn = "1"
      vim.cmd [[highlight! link CursorLine Visual]]
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        setopt = true,
        ft_ignore = { "NvimTree" },
        foldfunc = "builtin",
        segments = {
          {
            text = { " ", builtin.foldfunc, " " },
            condition = { builtin.not_empty, true, builtin.not_empty },
            click = "v:lua.ScFa",
          },
          { text = { "%s" }, click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
      }
    end,
  },
}