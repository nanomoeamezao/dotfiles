-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require('nvim-surround').setup {}
    end,
    lazy = false,
  },
  { 'vim-scripts/ReplaceWithRegister', lazy = false },
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end,
    lazy = false,
  },
  { 'windwp/nvim-autopairs', opts = { check_ts = true } },
}
