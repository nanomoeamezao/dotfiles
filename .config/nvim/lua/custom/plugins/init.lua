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
   },
   ["vim-scripts/ReplaceWithRegister"] = {
      after = "nvim-treesitter",
   },
   ["github/copilot.vim"] = {
      run = "Copilot setup",
      config = function()
         vim.cmd [[
        let g:copilot_no_tab_map = v:true
        ]]
      end,
   },
   ["hrsh7th/cmp-copilot"] = {
      after = "nvim-cmp",
   },
   ["mfussenegger/nvim-dap"] = {
      config = function() end,
   },
   ["leoluz/nvim-dap-go"] = {
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
      config = function()
         require("dapui").setup()
      end,
   },
   ["theHamsta/nvim-dap-virtual-text"] = {
      config = function()
         require("nvim-dap-virtual-text").setup()
      end,
   },
   -- ["TimUntersberger/neogit"] = {
   --    config = function()
   --       require("neogit").setup {}
   --    end,
   -- },
   ["sindrets/diffview.nvim"] = {
      config = function()
         require("diffview").setup {}
      end,
   },
   -- ["karb94/neoscroll.nvim"] = {
   --    config = function()
   --       require("neoscroll").setup()
   --    end,
   --
   --    -- lazy loading
   --    setup = function()
   --       nvchad.packer_lazy_load "neoscroll.nvim"
   --    end,
   -- },
   ["folke/todo-comments.nvim"] = {
      config = function()
         require("todo-comments").setup()
      end,
   },
}
