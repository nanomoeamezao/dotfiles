local M = {}

-- overriding default plugin configs!
M.treesitter = {
   ensure_installed = {
      "lua",
      "vim",
      "html",
      "css",
      "go",
      "javascript",
      "json",
      "toml",
      "markdown",
      "c",
      "bash",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   textobjects = {
      select = {
         enable = true,
         -- Automatically jump forward to textobj, similar to targets.vim
         lookahead = true,
         keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
         },
      },
   },
   rainbow = {
      enable = true,
      extended_mode = true,
   },
   autotag = {
      enable = true,
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
}

local cmp = require "cmp"
M.nvim_cmp = {
   preselect = cmp.PreselectMode.None,
}

return M
