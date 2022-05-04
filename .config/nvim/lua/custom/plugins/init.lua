return {

   {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,
   },
   {
      "nvim-telescope/telescope-fzf-native.nvim",
      after = "telescope.nvim",
      run = "make",
   },

   {
      "nvim-telescope/telescope-media-files.nvim",
      after = "telescope.nvim",
      config = function()
         require("telescope").setup {
            extensions = {
               media_files = {
                  filetypes = { "png", "webp", "jpg", "jpeg" },
               },
               -- fd is needed
            },
            fzf = {
               fuzzy = true, -- false will only do exact matching
               override_generic_sorter = true, -- override the generic sorter
               override_file_sorter = true, -- override the file sorter
            },
         }
         require("telescope").load_extension "media_files"
         require("telescope").load_extension "fzf"
      end,
   },

   {
      "Pocco81/TrueZen.nvim",
      cmd = {
         "TZAtaraxis",
         "TZMinimalist",
         "TZFocus",
      },
      config = function()
         require "custom.plugins.truezen"
      end,
   },
   {
      "ur4ltz/surround.nvim",
      config = function()
         require("surround").setup { mappings_style = "surround" }
      end,
   },
   { "nvim-treesitter/nvim-treesitter-textobjects" },
   { "p00f/nvim-ts-rainbow" },
   {
      "windwp/nvim-ts-autotag",
      ft = { "html", "javascriptreact" },
      after = "nvim-treesitter",
      config = function()
         require("nvim-ts-autotag").setup()
      end,
   },
   {
      "ggandor/lightspeed.nvim",
      config = function()
         require("lightspeed").setup {
            ignore_case = true,
         }
      end,
   },
   {
      "folke/twilight.nvim",
      config = function()
         require("twilight").setup {
            context = 10,
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
   { "vim-scripts/ReplaceWithRegister" },
   {
      "github/copilot.vim",
      run = "Copilot setup",
      config = function()
         vim.cmd [[
         imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        let g:copilot_no_tab_map = v:true
        ]]
      end,
   },
   {
      "hrsh7th/cmp-copilot",
      after = "nvim-cmp",
   },
   {
      "mfussenegger/nvim-dap",
      config = function() end,
   },
   {
      "leoluz/nvim-dap-go",
      config = function()
         require("dap-go").setup()
         local dap = require "dap"
         table.insert(dap.configurations.go, {
            type = "go",
            request = "attach",
            name = "scanner debug",
            program = "/home/neo/code/scanner/cmd/scanner-server/",
            args = "config=/home/neo/code/scanner/configs/scanner/localhost/config.json",
         })
      end,
   },
   {
      "rcarriga/nvim-dap-ui",
      config = function()
         require("dapui").setup()
      end,
      requires = { "mfussenegger/nvim-dap" },
   },
   {
      "theHamsta/nvim-dap-virtual-text",
      config = function()
         require("nvim-dap-virtual-text").setup()
      end,
      requires = { "mfussenegger/nvim-dap" },
   },
}
