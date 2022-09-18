vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',  opts = {} },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'go' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = false },
  indent = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

vim.keymap.set('n', '<leader>ff', "<cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>")
vim.keymap.set('n', '<leader>fw', "<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>")
vim.keymap.set('n', '<leader>x', "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>")
vim.keymap.set('n', '<leader>X', "<cmd>call VSCodeNotify('workbench.action.closeAllEditors')<cr>")
vim.keymap.set('n', '<leader>cm', "<cmd>call VSCodeNotify('git.viewHistory')<cr>")
vim.keymap.set('n', '<leader>sg', "<cmd>call VSCodeNotify('workbench.view.scm')<cr>")
vim.keymap.set('n', '<tab>', "<cmd>call VSCodeNotify('workbench.action.nextEditor')<cr>")
vim.keymap.set('n', '<S-tab>', "<cmd>call VSCodeNotify('workbench.action.previousEditor')<cr>")
vim.keymap.set('n', '<leader>fr', "<cmd>call VSCodeNotify('references-view.findReferences')<cr>")
vim.keymap.set('n', ']c', "<cmd>call VSCodeNotify('editor.action.dirtydiff.next')<cr>")
vim.keymap.set('n', '[c', "<cmd>call VSCodeNotify('editor.action.dirtydiff.previous')<cr>")
vim.keymap.set('n', 'ge', "<cmd>call VSCodeNotify('editor.action.marker.next')<cr>")
vim.keymap.set('n', 'gi', "<cmd>call VSCodeNotify('editor.action.goToImplementation')<cr>")
vim.keymap.set('n', ']d', "<cmd>call VSCodeNotify('editor.action.marker.next')<cr>")
vim.keymap.set('n', '[d', "<cmd>call VSCodeNotify('editor.action.marker.prev')<cr>")
vim.keymap.set('n', '<leader>cc', "<cmd>call VSCodeNotify('git.commitAll')<cr>")
vim.keymap.set('n', '<leader>cp', "<cmd>call VSCodeNotify('git.push')<cr>")
vim.keymap.set('n', '<leader>gt', "<cmd>call VSCodeNotify('git.openAllChanges')<cr>")
vim.keymap.set('n', 'zc', "<cmd>call VSCodeNotify('editor.fold')<cr>")
vim.keymap.set('n', 'zR', "<cmd>call VSCodeNotify('editor.unfoldAll')<cr>")
vim.keymap.set('n', 'zo', "<cmd>call VSCodeNotify('editor.unfold')<cr>")
-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
