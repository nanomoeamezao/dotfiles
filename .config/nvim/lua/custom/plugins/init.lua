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
   { "folke/twilight.nvim" },
   { "vim-scripts/ReplaceWithRegister" },
   {
      "github/copilot.vim",
      after = "nvim-lspconfig",
      run = "Copilot setup",
   },
}
