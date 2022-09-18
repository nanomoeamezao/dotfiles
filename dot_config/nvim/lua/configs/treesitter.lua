return {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "html",
    "python",
    "css",
    "go",
    "gomod",
    "javascript",
    "typescript",
    "json",
    "toml",
    "markdown",
    "c",
    "bash",
    "regex",
    "gitignore",
    "dockerfile",
    "comment",
    "yaml",
    "sql",
    "dockerfile",
  },
  highlight = { enable = true },
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
  autotag = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = { "yaml", "python", "c", "cpp" },
  },
}
