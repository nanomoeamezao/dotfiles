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
   ["vim-scripts/ReplaceWithRegister"] = {},
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
   },
   ["zbirenbaum/copilot-cmp"] = {},
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
   ["nvim-telescope/telescope-dap.nvim"] = {
      after = { "nvim-dap", "telescope.nvim" },
      config = function()
         require("telescope").load_extension "dap"
      end,
   },
   ["sindrets/diffview.nvim"] = {
      requires = "plenary",
      config = function()
         require("diffview").setup {}
      end,
      cmd = { "DiffviewOpen" },
   },
   ["folke/todo-comments.nvim"] = {
      config = function()
         require("todo-comments").setup()
      end,
   },
   ["nvim-telescope/telescope-ui-select.nvim"] = {
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "ui-select"
      end,
   },
   ["benfowler/telescope-luasnip.nvim"] = {
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "luasnip"
      end,
      module = "telescope._extensions.luasnip", -- if you wish to lazy-load
   },
   ["kelly-lin/telescope-ag"] = {
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "ag"
      end,
   },
   ["wgwoods/vim-systemd-syntax"] = { ft = { "systemd" } },
}
