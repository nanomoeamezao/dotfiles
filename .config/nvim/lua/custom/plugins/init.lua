return {
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

   ["Pocco81/TrueZen.nvim"] = {
      cmd = {
         "TZAtaraxis",
         "TZMinimalist",
         "TZFocus",
      },
      config = function()
         require "custom.plugins.truezen"
      end,
      disable = true,
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
   ["ggandor/lightspeed.nvim"] = {
      config = function()
         require("lightspeed").setup {
            ignore_case = true,
         }
      end,
      requires = { "tpope/vim-repeat" },
   },
   ["folke/twilight.nvim"] = {
      config = function()
         require("twilight").setup {
            context = 20,
            treesitter = true,
            expand = {
               "function",
               "method",
               "table",
               "if_statement",
            },
         }
      end,
      disable = true,
   },
   ["vim-scripts/ReplaceWithRegister"] = {},
   ["github/copilot.vim"] = {
      config = function()
         vim.cmd [[
        let g:copilot_no_tab_map = v:true
        ]]
      end,
      -- commit = "042543ffc2e77a819da0415da1af6b1842a0f9c2",
   },
   ["hrsh7th/cmp-copilot"] = {
      after = "nvim-cmp",
   },
   ["mfussenegger/nvim-dap"] = {},
   ["leoluz/nvim-dap-go"] = {
      after = "nvim-dap",
      config = function()
         require("dap-go").setup()
         local dap = require "dap"


         table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            showLog = true,
            name = "scanner debug",
            program = "/home/neo/code/scanner/cmd/scanner-server/",
            buildFlags = "-tags static_ui",
         })
         table.insert(dap.configurations.go, {
            type = "go",
            request = "launch",
            showLog = true,
            name = "netscan debug",
            program = "/home/neo/code/scanner/netscan-service/cmd/netscan-service/",
         })
      end,
   },
   ["rcarriga/nvim-dap-ui"] = {
      after = "nvim-dap",
      config = function()
         require("dapui").setup()
         local dap, dapui = require "dap", require "dapui"
         dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
         end
         dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
         end
         dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
         end
      end,
   },
   ["theHamsta/nvim-dap-virtual-text"] = {
      after = "nvim-dap",
      config = function()
         require("nvim-dap-virtual-text").setup()
      end,
   },
   ["sindrets/diffview.nvim"] = {
      config = function()
         require("diffview").setup {}
      end,
   },
   ["folke/todo-comments.nvim"] = {
      config = function()
         require("todo-comments").setup()
      end,
      disable = true,
   },
   ["nvim-telescope/telescope-ui-select.nvim"] = {
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "ui-select"
      end,
   },
}
